require 'writeexcel'

class Excel

  @@alphabet = ('A'..'Z').to_a
  @@alphabet_array = @@alphabet + @@alphabet.product(@@alphabet).map(&:join)

  def initialize(file_name)
    @workbook = WriteExcel.new(file_name)
  end

  def create_worksheets(number)
    @worksheet = Array.new
    (0...number).each do |l|
      @worksheet.push(@workbook.add_worksheet)
    end
    return @worksheet
  end

  def create_headers(number_of_headers, column_names)
    @worksheet.each do |worksheet|
      (0...number_of_headers).each do |h|
        worksheet.write("#{@@alphabet_array[h]}1", column_names[h])
      end
    end
  end

  def create_excel_content(content)
    @worksheet.each do |worksheet|
      #starts from second row in Excel
      j = 2
      content.each do |row|
        #starts from letter 'A'
        i = 0
        row.each do |value|
          worksheet.write("#{@@alphabet_array[i]}#{j}", value)
          i += 1
        end
        j += 1
      end
    end
  end

  def close
    @workbook.close
  end
end
