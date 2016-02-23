class Newsletter < ActiveRecord::Base
  has_many :campaigns, dependent: :nullify

  def body_for(shot)
    html_body = parse_document(self.body)
    html_body = replace_links(shot.id, html_body)
    html_body = append_footer(shot.id, html_body)

    domain = self.from.split('@')[1].gsub!('>', '')

    set_domain_and_return(domain, html_body)
  end

  private

  def replace_links(shot_id, body)
    body.css('a').each do |a|
      link = Link.create(shot_id: shot_id, url: a[:href])
      a[:href] = "http://:domain/links/#{link.id}"
    end

    body
  end

  def append_footer(shot_id, body)
    footer = load_footer.gsub!(':shot_id', shot_id.to_s)
    parse_fragment(footer).parent = body.at_css('body')
  end

  def set_domain_and_return(domain, body)
    body.to_html.gsub!(':domain', domain)
  end

  def parse_document(body)
    Nokogiri::HTML.parse(body, nil, 'UTF-8')
  end

  def parse_fragment(node)
    Nokogiri::HTML::DocumentFragment.parse(node)
  end

  def load_footer
    File.open("#{Rails.root}/app/views/newsletters/_email_footer.html", "rb").read
  end
end
