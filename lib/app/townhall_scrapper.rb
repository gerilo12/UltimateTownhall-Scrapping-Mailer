require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'

class Scrapper
  attr_reader :contacts

  def initialize #définition des variables d'instance
    @website_url = "http://annuaire-des-mairies.com/"
    @region_pages = ["pas-de-calais.html", "nord.html", "nord-2.html", "nord-3.html","pas-de-calais-2.html", "pas-de-calais-3.html", "seine-maritime.html", "seine-maritime-2.html", "seine-maritime-3.html"]
    @town_urls = []
    @contacts = []

    get_all_the_contacts_of_region_townhalls #appel des méthodes qui vont scrapper les données
    save_contacts_in_json #et les mettre dans le fichier JSON
  end

  def get_all_the_contacts_of_region_townhalls #création de l'array qui contient les contacts
    get_all_the_urls_of_region_townhalls #appel de la méthode qui récupère les URLs
    @town_urls.each do |town_url| #itération sur chaque URL
      contact = get_the_email_of_a_townhal_from_its_webpage(town_url) #appel de la méthode pour récupérer les infos de chaque mairie
      p contact
      @contacts << contact #stocke chaque contact dans l'array
    end
    @contacts.compact #les erreurs 404 renvoyant nil, .compact permet de supprimer ces nil
  end

  def get_all_the_urls_of_region_townhalls #récupère l'url de chaque mairie
    @region_pages.each do |region_page| #itération sur chaque page URL
      page = Nokogiri::HTML(open(@website_url + region_page))
      page.xpath("//a[@class = 'lientxt']/@href").each do |town| #itération sur chaque lien
        @town_urls << @website_url + town.text[2..-1] #stocke l'ensemble des URLs
      end
    end
  end

  def get_the_email_of_a_townhal_from_its_webpage(url) #méthode qui récupère nom, mail et département de chaque mairie
    begin
      contact = {}
      page = Nokogiri::HTML(open(url))
      contact[:name] = page.xpath("/html/body/div/main/section[1]/div/div/div/p[1]/strong[1]/a").text #récupération du nom de la ville
      contact[:email] = page.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text #récupération de l'email de la ville
      contact[:region] = page.xpath("/html/body/div/main/section[4]/div/table/tbody/tr[1]/td[2]").text #récupération du département de la ville
      contact
    rescue OpenURI::HTTPError => the_error #évite les URLs renvoyant une erreur 404
    end
  end

  def save_contacts_in_json #méthode qui sauvegarde toutes les infos dans un fichier JSON
    File.open("../../db/contacts.json","w") do |f|
      f.write(JSON.pretty_generate(@contacts))
    end
  end
end

if __FILE__ == $0 #permet de tester le code uniquement depuis ce fichier
  scrap = Scrapper.new("http://annuaire-des-mairies.com/")
end
