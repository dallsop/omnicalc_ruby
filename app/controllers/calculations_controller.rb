class CalculationsController < ApplicationController

  ######################
  ##### WORD COUNT #####
  ######################

  def word_count
    @text = params[:user_text]
    @special_word = params[:user_word]

    @character_count_with_spaces = @text.length

    @character_count_without_spaces = @text.gsub(' ','').length

    @word_count = @text.split.length

    @occurrences = @text.upcase.split.count(@special_word.upcase)

  end

  ########################
  ##### LOAN PAYMENT #####
  ########################

  def loan_payment
    @apr = params[:annual_percentage_rate].to_f
    @years = params[:number_of_years].to_i
    @principal = params[:principal_value].to_f

    @monthly_payment = (@apr / 1200 * @principal) / (1 - (1 + @apr / 1200) ** -(@years * 12))

  end

  ########################
  ##### TIME BETWEEN #####
  ########################

  def time_between
    @starting = Chronic.parse(params[:starting_time])
    @ending = Chronic.parse(params[:ending_time])

    difference = @ending - @starting

    @seconds = difference
    @minutes = difference / 60
    @hours = difference / 3600      #60 * 60
    @days = difference / 86400      #60 * 60 * 24
    @weeks = difference / 604800    #60 * 60 * 24 * 7
    @years = difference / 31557600  #60 * 60 * 24 * 365.25

  end

  #############################
  ##### DESCRIPTIVE STATS #####
  #############################

  def descriptive_statistics
    @numbers = params[:list_of_numbers].gsub(',', '').split.map(&:to_f)

    @sorted_numbers = @numbers.sort

    @count = @numbers.count

    @minimum = @numbers.min

    @maximum = @numbers.max

    @range = @maximum - @minimum

    if @count % 2 == 1 #odd
      @median = @sorted_numbers[@count / 2]
    else #even
      @median = (@sorted_numbers[@count / 2 - 1] + @sorted_numbers[@count / 2]) / 2
    end

    @sum = @numbers.sum

    @mean = @sum / @count

    #----VARIANCE----#
    #loop through all values, sum squared differences, divide by count
    @variance = 0
    @sorted_numbers.each do|nums|
      @variance += (nums - @mean) ** 2
    end
    @variance = @variance / @count

    @standard_deviation = @variance ** 0.5

    #----MODE----#
    #loop through sorted values, create hash of unique keys with number counts as values, return key with max value
    #unless only one value, then mode = value
    #(separate from variance loop above for clarity)
    if @numbers.count == 1
      @mode = @numbers[0]
    else
      counts = Hash.new(0)
      @sorted_numbers.each do|nums|
        counts[nums] += 1
      end
      @mode = counts.key(counts.values.max)
    end
  end
end
