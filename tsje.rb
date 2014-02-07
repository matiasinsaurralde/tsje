require 'nokogiri'

USER_AGENT = 'Mozilla Firefox'
URL = 'http://tsje.gov.py/e2013/dinamics/app/consulta-al-padron.php'
REFERER = 'http://tsje.gov.py/e2013/consulta-al-padron.html'

module TSJE
  def self.consulta( cedula )
    raw_html = `curl -s -A '#{USER_AGENT}' -H 'X-Requested-With: XMLHttpRequest' -H 'Referer: #{REFERER}' #{URL} --data 'cedula=#{cedula}'`
    print raw_html
  end
end
