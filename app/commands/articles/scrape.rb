module Articles
  class Scrape < Mutations::Command
    
    ROOT_URL = "https://intercom.help"
    
    required do
      string :help_center_url
    end
    
    optional do
      boolean :quiet, default: false
    end
    
    def execute
      @pages = []
      @pages << help_center_url
      collect_all_articles
    end
    
    def collect_all_articles
      for page in @pages
        Rails.logger.info "Found page: " + page.to_s unless quiet
        if page.to_s.include? "mailto"
          Rails.logger.warn "Ignoring 'mailto' anchor"
          next
        end
        @pages + collect_all_articles_from_page(page)
      end
    end
    
    def collect_all_articles_from_page(page)
      require 'open-uri'
      if page.start_with?(help_center_url)
        open_page = Nokogiri::HTML(open(ROOT_URL + page.to_s))
        build_article(open_page, page.to_s)
        for link in open_page.css('a')
          if @pages.include?(link['href']) || link['href'].nil?
            next
          else
            if page.start_with?(help_center_url)
              Rails.logger.info "Confirmed article: " + page.to_s unless quiet
              @pages << link['href'] unless link['href'].start_with?("http")
            end
          end
        end
      end
    end
    
    def build_article(page, slug)
      if page.css('h1.t__h1').present? && page.css('article').present?
        article = {title: page.css('h1.t__h1').text, body: page.css('article')}
        if page.css('.breadcrumb a').length == 4
          article['category'] = page.css('.breadcrumb a')[1].text
          article['section'] = page.css('.breadcrumb a')[2].text
        elsif page.css('.breadcrumb a').length == 3
          article['category'] = page.css('.breadcrumb a')[1].text
        end
        article['page_slug'] = slug
        article['language'] = determine_language(slug)
        article['id'] = determine_id(slug)
        create_or_update_article(article)
      end
    end
    
    def determine_language(slug)
      elements = slug.split('/')
      elements[2].length == 2 ? elements[2] : nil
    end
    
    def determine_id(slug)
      elements = slug.split('/')
      sub_elements = elements[4].split('-')
      sub_elements[0].to_i
    end
    
    def create_or_update_article(article)
      Article.exists?(article['id']) ? update_article(article) : create_article(article)
    end
    
    def create_article(article)
      record = Article.new(article)
      if record.valid?
        record.save
        Rails.logger.info "Article with id " + record.id.to_s + " created." unless quiet
      else
        record_error(article['page_slug'].to_s)
      end
    end
    
    def update_article(article)
      record = Article.find(article['id'])
      begin record.update_attributes(article)
        Rails.logger.info "Article with id " + record.id.to_s + " updated." unless quiet
      rescue ActiveRecord::RecordInvalid => invalid
        Rails.logger.warn (invalid.record.errors.inspect)
      end
    end
    
    def record_error(slug)
      Rails.logger.info "Validation error occured on " + slug unless quiet
    end
  end
end
