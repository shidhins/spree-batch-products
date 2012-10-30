require 'roo'
class SpreadsheetDocument
  def self.load xls
    file_name = xls.url
    case file_name.split('.').last
      when 'xls'
        Excel.new file_name
      when 'xlsx'
        Excelx.new file_name
      when 'ods'
        Openoffice.new file_name
      when 'csv'
        Csv.new file_name
    end
  end
end
