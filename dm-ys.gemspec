# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-ys}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["maiha"]
  s.date = %q{2009-09-04}
  s.description = %q{a DataMapper extension that uses html table as its schema and data powerfully like YunkerStar}
  s.email = %q{maiha@wota.jp}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["LICENSE", "README", "Rakefile", "lib/dm-ys.rb", "lib/dm-ys", "lib/dm-ys/base.rb", "lib/dm-ys/config.rb", "lib/dm-ys/element_property.rb", "lib/dm-ys/indexed_property.rb", "lib/dm-ys/memory_repository.rb", "lib/dm-ys/scraper.rb", "lib/dm-ys/cached_accessor.rb", "lib/dm-ys/proxy.rb", "spec/config_spec.rb", "spec/data", "spec/data/uniq2.html", "spec/data/sorted2.html", "spec/data/sorted1.html", "spec/data/th.html", "spec/data/plugins1.html", "spec/data/gem_maintainers.html", "spec/data/plugins2.html", "spec/data/uniq1.html", "spec/data/blank.html", "spec/models", "spec/models/style.rb", "spec/models/gem_maintainer.rb", "spec/models/plugin.rb", "spec/composite_scraper_spec.rb", "spec/uniq_record_spec.rb", "spec/attribute_spec.rb", "spec/anonymous_spec.rb", "spec/scraper_spec.rb", "spec/indexed_property_spec.rb", "spec/spec_helper.rb", "spec/pagination_spec.rb", "spec/scraper_utils_spec.rb", "spec/proxy_spec.rb"]
  s.homepage = %q{http://github.com/maiha/dm-ys}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{a DataMapper extension that uses html table as its schema and data powerfully like YunkerStar}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0"])
      s.add_runtime_dependency(%q<hpricot>, [">= 0"])
      s.add_runtime_dependency(%q<maiha-dsl_accessor>, [">= 0.3.2"])
    else
      s.add_dependency(%q<dm-core>, [">= 0"])
      s.add_dependency(%q<hpricot>, [">= 0"])
      s.add_dependency(%q<maiha-dsl_accessor>, [">= 0.3.2"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0"])
    s.add_dependency(%q<hpricot>, [">= 0"])
    s.add_dependency(%q<maiha-dsl_accessor>, [">= 0.3.2"])
  end
end
