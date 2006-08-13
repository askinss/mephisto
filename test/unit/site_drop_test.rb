require File.dirname(__FILE__) + '/../test_helper'

class SiteDropTest < Test::Unit::TestCase
  fixtures :sites, :sections
  
  def setup
    @site = Mephisto::Liquid::SiteDrop.new(sites(:first))
  end

  def test_should_convert_site_to_drop
    assert_kind_of Liquid::Drop, sites(:first).to_liquid
  end

  def test_should_list_all_sections
    assert_equal [sections(:home), sections(:about)], @site.sections.collect(&:section)
    assert_equal [false, false],                      @site.sections.collect(&:current)
  end
  
  def test_should_default_to_no_current_section
    assert_nil @site.current_section
  end
  
  def test_should_show_current_section
    @site = Mephisto::Liquid::SiteDrop.new(sites(:first), sections(:about))
    assert_equal sections(:about), @site.current_section.source
    assert_equal [false, true], @site.sections.collect(&:current)
  end
  
  def test_should_list_only_blog_sections
    assert_equal [sections(:home)], @site.blog_sections.collect(&:section)
  end
  
  def test_should_list_only_paged_sections
    assert_equal [sections(:about)], @site.page_sections.collect(&:section)
  end

  def test_liquid_keys
    [:host, :subtitle, :title, :articles_per_page].each do |attr|
      assert_equal sites(:first).send(attr), @site.before_method(attr)
    end
  end
end