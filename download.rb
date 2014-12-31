require 'rubygems'
require 'mechanize'

def iterate(page, ward, page_number)
  puts "processing #{ward}-#{page_number}"
  next_page = page.link_with(:text => 'next')
  if next_page then
    result = next_page.click()
    File.open("results/%02d-%08d.html" % [ward, page_number], 'w') do |f|
      f.write(result.body)
    end
    sleep(2)
    iterate(result, ward, page_number + 1)
  end
end

def get_ward(ward)
  a = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
  }
  a.get('https://www.taxpayerservicecenter.com/RP_Search.jsp?search_type=Assessment') do |page|
    page = page.form_with(:name => 'SearchForm') do |search|
      search.selectWard = ward
    end.submit

    File.open("results/%02d-%08d.html" % [ward, 0], 'w') do |f|
      f.write(page.body)
    end

    iterate(page, ward, 0)
  end
end


for ward in 2..8 do
  get_ward(ward.to_s)
end
