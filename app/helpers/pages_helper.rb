module PagesHelper
	BONUS = []
	def match6

		results = []
		
		years = ['https://www.lottery.net/pennsylvania/match-6-lotto/numbers/2025']

    years.each do |year|
      doc = Nokogiri::HTML(URI.open(year))
      doc.css('td li').each do |data|
        d = data.content.strip
        results.push(d) if d.to_i != 0
      end
    end

		draws = []

		(results.length/6).times do
			draws.push(results.shift(6))
		end

		targets = [1,10,20,30,40,49]
		numofdraws = [9,19,22,22,19,9]
		tn = Hash.new
		6.times do |i|
			tn[targets[i]] = numofdraws[i]
		end

		output = []
		c=0
		position_number = []
		holder = []
		tn.each do |k,v|
			nums = (1..49).map(&:to_i)
			hold = []
			draws.first(v).each do |draw|
				hold.push(draw[c].to_i)
			end
			hold.each do |number|
				nums.delete(number)
			end
			position_number << hold.uniq.sort
			holder.push(nums.min_by{|x| (x-k).abs})
			c+=1
		end
		output << position_number
		output << holder
		output
	end

	def powerball

		results = []
		
		years = ['https://www.lottery.net/powerball/numbers/2025',
						 'https://www.lottery.net/powerball/numbers/2024']

    years.each do |year|
      doc = Nokogiri::HTML(URI.open(year))
      doc.css('td li').each do |data|
        d = data.content.strip
        results.push(d) if d.to_i != 0
      end
    end

		draws = []

		300.times do |i|
			draws.push(results.shift(5))
			if (i+1).odd?
				BONUS.push(results.shift(1))
				results.shift(1)
			else
				BONUS.push(results.shift(1))
			end
		end

		targets = [1,17,35,52,69]
		numofdraws = [14,32,36,32,14]
		tn = Hash.new
		5.times do |i|
			tn[targets[i]] = numofdraws[i]
		end

		output = []
		c=0
		position_number = []
		holder = []
		tn.each do |k,v|
			nums = (1..69).map(&:to_i)
			hold = []
			draws.first(v).each do |draw|
				hold.push(draw[c].to_i)
			end
			hold.each do |number|
				nums.delete(number)
			end
			position_number << hold.uniq.sort
			holder.push(nums.min_by{|x| (x-k).abs})
			c+=1
		end
		output << position_number
		output << holder
		output << BONUS.flatten.uniq.last
	end

	def match6slots
		results = []
		picked_slots = Hash.new { |hash, key| hash[key] = Hash.new(-1) } # Default to -1 for missing numbers

		years = ['https://www.lottery.net/pennsylvania/match-6-lotto/numbers/2025',
						'https://www.lottery.net/pennsylvania/match-6-lotto/numbers/2024']

		# Define valid ranges for each slot
		slot_ranges = {
			1 => (1..5).to_a,
			2 => (6..15).to_a,
			3 => (16..25).to_a,
			4 => (26..35).to_a,
			5 => (36..44).to_a,
			6 => (45..49).to_a
		}

		# Scrape data
		years.each do |year|
			doc = Nokogiri::HTML(URI.open(year))
			doc.css('td li').each do |data|
				d = data.content.strip
				results.push(d) if d.to_i != 0
			end
		end

		# Organize draws
		draws = results.each_slice(6).to_a

		# Initialize all numbers within ranges for each slot
		slot_ranges.each do |slot, valid_numbers|
			valid_numbers.each do |number|
				picked_slots[slot][number.to_s] = -1 # Default to -1 for each number
			end
		end

		# Update slots with draw indices
		draws.reverse_each.with_index do |draw, index|
			draw.each_with_index do |number, slot|
				# Only update if the number is valid for the slot
				if slot_ranges[slot + 1].include?(number.to_i)
					draw_index = draws.size - index - 1
					picked_slots[slot + 1][number] = draw_index
				end
			end
		end

		# Display results
		picked_slots.each do |slot, numbers|
			puts "Slot #{slot}:"
			numbers.each do |number, draw_index|
				puts "  Number #{number}: Draw Index #{draw_index}"
			end
		end
	end # match6slots function


	def fetch_powerball_data
    # Initialize results arrays
    results = []
    bonus = []

    # Define years for scraping
    years = [
      'https://www.lottery.net/powerball/numbers/2025',
      'https://www.lottery.net/powerball/numbers/2024'
    ]

    # Scrape data
    years.each do |year|
      doc = Nokogiri::HTML(URI.open(year))
      doc.css('td li').each do |data|
        d = data.content.strip
        results.push(d) if d.to_i != 0
      end
    end

    # Organize draws and bonus data
    draws = []
    312.times do |i|
      draws.push(results.shift(5))
      if (i + 1).odd?
        bonus.push(results.shift(1))
        results.shift(1)
      else
        bonus.push(results.shift(1))
      end
    end

    # Initialize picked_slots hash
    picked_slots = Hash.new { |hash, key| hash[key] = Hash.new(-1) }

    # Define slot ranges
    slot_ranges = {
      1 => (1..9).to_a,
      2 => (10..26).to_a,
      3 => (27..43).to_a,
      4 => (44..60).to_a,
      5 => (61..69).to_a
    }

    # Initialize all numbers within ranges for each slot
    slot_ranges.each do |slot, valid_numbers|
      valid_numbers.each do |number|
        picked_slots[slot][number.to_s] = -1 # Default to -1 for each number
      end
    end

    # Update slots with draw indices
    draws.reverse_each.with_index do |draw, index|
      draw.each_with_index do |number, slot|
        # Only update if the number is valid for the slot
        if slot_ranges[slot + 1].include?(number.to_i)
          draw_index = draws.size - index - 1
          picked_slots[slot + 1][number] = draw_index
        end
      end
    end

    # Return the picked_slots hash for further use in views
    picked_slots
  end #powerslots method

end #module


