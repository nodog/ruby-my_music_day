require 'date'

def regular_seed(cli_argument)

  if cli_argument
    if cli_argument == "random"
      seed = rand(BIG_INTEGER)
    elsif cli_argument == "tomorrow"
      tomorrow = Date.today + 1
      puts "seed based on tomorrow's date = #{tomorrow}"
      seed = tomorrow.year() * 1000 + tomorrow.yday()
      date_of = tomorrow.strftime("%F")
    else
      seed = cli_argument.to_i
    end
  else
    this_day = Date.today
    puts "seed based on today's date = #{this_day}"
    seed = this_day.year() * 1000 + this_day.yday()
  end

  seed
end
