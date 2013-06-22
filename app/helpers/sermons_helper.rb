module SermonsHelper

  def top_sermons_month
    #sfrutto il default scope perchè mi servono le top settimanali
    Sermon.all(:limit => 3)
  end

end
