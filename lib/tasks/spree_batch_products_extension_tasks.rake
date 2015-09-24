namespace :spree_batch do
  task :products_backup, [:fields_for_backup] => :environment do |task, args|
    require 'csv'

    if defined?(Apartment::Tenant)
      filepath = File.join(Rails.root, "backups", Apartment::Tenant.current_tenant)
      FileUtils.mkdir_p(filepath)
    else
      filepath = File.join(Rails.root, "public", "downloads")
      FileUtils.mkdir_p(filepath)
    end
    filename = "products-backup-#{Time.now.strftime('%Y-%m-%d-%H-%M')}.csv"
    puts "\n" * 2
    puts "Preparing to dump #{filename} into #{filepath}"
    puts "\n" *2

    cr = "\r" # move cursor to beginning of line
    clear = "\e[0K"
    reset = cr + clear# reset lines

    counter = 0
    total = Spree::Product.for_backup.count

    puts "#{total} products total are about to be processed."
    total = total/100.0

    if ARGV.last =~ /^([\w_]+,)+[\w_]+$/
      headings = ARGV.last.split(',')
    elsif args[:fields_for_backup].present?
      headings = args[:fields_for_backup].split('/')
    else
      headings = Spree::Product.fields_for_backup
    end

    CSV.open(File.join(filepath, filename), "w") do |csv|
      csv << headings

      Spree::Product.for_backup.find_in_batches(:batch_size => 50) do |products|

        products.each do |product|
          counter += 1

          values = headings.map do |attr|
            product.send(attr).to_s
          end

          csv << values

          percentage = (counter/total).round(2)
          print "#{reset}#{percentage}%"
          $stdout.flush
          sleep 0 # yield to OS and other processes, important for production
        end
      end
    end

    puts "\n" * 2
    puts "And done."
  end
  task :variants_backup, [:fields_for_backup] => :environment do |task, args|
    require 'csv'

    if defined?(Apartment::Tenant)
      filepath = File.join(Rails.root, "backups", Apartment::Tenant.current_tenant)
      FileUtils.mkdir_p(filepath)
    else
      filepath = File.join(Rails.root, "public", "downloads")
      FileUtils.mkdir_p(filepath)
    end
    filename = "variants-backup-#{Time.now.strftime('%Y-%m-%d-%H-%M')}.csv"
    puts "\n" * 2
    puts "Preparing to dump #{filename} into #{filepath}"
    puts "\n" *2

    cr = "\r" # move cursor to beginning of line
    clear = "\e[0K"
    reset = cr + clear# reset lines

    counter = 0
    total = Spree::Variant.for_backup.count

    puts "#{total} products total are about to be processed."
    total = total/100.0

    if ARGV.last =~ /^([\w_]+,)+[\w_]+$/
      headings = ARGV.last.split(',')
    elsif args[:fields_for_backup].present?
      headings = args[:fields_for_backup].split('/')
    else
      headings = Spree::Variant.fields_for_backup
    end

    CSV.open(File.join(filepath, filename), "w") do |csv|
      csv << headings

      Spree::Variant.for_backup.find_in_batches(:batch_size => 50) do |products|

        products.each do |product|
          counter += 1

          values = headings.map do |attr|
            product.send(attr).to_s
          end

          csv << values

          percentage = (counter/total).round(2)
          print "#{reset}#{percentage}%"
          $stdout.flush
          sleep 0 # yield to OS and other processes, important for production
        end
      end
    end

    puts "\n" * 2
    puts "And done."
  end
end
