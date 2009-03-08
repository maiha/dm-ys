class BlankHtml
  include DataMapper::YS
  uri spec_data_path("blank.html")
end

class BlankStyle
  include DataMapper::YS
  uri spec_data_path("plugins1.html")
end

class TableStyle < BlankStyle
  uri spec_data_path("plugins1.html")
  table "table.main"
end

class TheadStyle < BlankStyle
  uri spec_data_path("plugins1.html")
  thead "table.main"
end

class ThStyle
  include DataMapper::YS
  uri spec_data_path("th.html")
end
