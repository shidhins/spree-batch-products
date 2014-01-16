require 'roo'
class SpreadsheetDocument
  def self.load xls
    file_name = xls.url(:default, timestamp: false)
    case file_name.split('.').last
      when 'xls'
        Roo::Excel.new file_name
      when 'xlsx'
        Roo::Excelx.new file_name
      when 'ods'
        Roo::Openoffice.new file_name
      when 'csv'
        Roo::Csv.new file_name
    end
  end
end
