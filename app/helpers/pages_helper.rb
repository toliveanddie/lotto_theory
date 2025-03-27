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
end
