require 'roo'
class SpreadsheetDocument
  def self.load(file_name)
    case file_name.split('.').last
      when 'xls'
        Excel.new(file_name)
      when 'xlsx'
        Excelx.new(file_name)
      when 'ods'
        Openoffice.new(file_name)
      else
        Csv.new(file_name)
    end
  end
end
