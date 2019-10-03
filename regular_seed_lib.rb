require 'date'

def regular_seed(cli_argument)

  if cli_argument
    if cli_argument == "random"
      seed = rand(BIG_INTEGER)
    elsif cli_argument == "tomorrow"
      tomorrow = Date.today + 1
      seed = tomorrow.year() * 1000 + tomorrow.yday()
      date_of = tomorrow.strftime("%F")
    else
      seed = cli_argument.to_i
    end
  else
    this_day = Date.today
    seed = this_day.year() * 1000 + this_day.yday()
  end

  seed
end
