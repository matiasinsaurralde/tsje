require 'nokogiri'

USER_AGENT = 'Mozilla Firefox'
URL = 'http://tsje.gov.py/e2013/dinamics/app/consulta-al-padron.php'
REFERER = 'http://tsje.gov.py/e2013/consulta-al-padron.html'

module TSJE
  def self.consulta( cedula )

    result = { :cedula => cedula }
    raw_html = `curl -s -A '#{USER_AGENT}' -H 'X-Requested-With: XMLHttpRequest' -H 'Referer: #{REFERER}' #{URL} --data 'cedula=#{cedula}'`
    document = Nokogiri::HTML( raw_html )
    document.css('.row-fluid')[1].css('div').each_with_index do |div, index|
      case
        when index == 0
          result.store( :nombre, div.inner_text.split(' ').map { |s| s.strip.downcase.capitalize }.join(' ') )
        when index == 1
          if div.inner_text.downcase == 'm'
            sexo = 0
          else
            sexo = 1
          end
          result.store( :genero, sexo )
        when index == 2
          result.store( :nacionalidad, div.inner_text.downcase.capitalize )
      end
    end

    result.store( :departamento, document.css('.row-fluid .span6')[1].inner_text.downcase.capitalize )
    result.store( :distrito, document.css('.row-fluid .span6')[3].inner_text().downcase.capitalize )
    result.store( :zona, document.css('.row-fluid .span6')[5].inner_text().downcase.capitalize )
    result.store( :local, document.css('.row-fluid .span6')[7].inner_text().strip() )

    p result
  end
end
