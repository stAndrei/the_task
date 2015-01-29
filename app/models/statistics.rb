class Statistics

  def revenue
    gross_sales - payouts
  end

  def rejection_rate
    count_jobs('rejected') / count_jobs(%w(accepted done)) * 100
  end

  def predicted_revenue(future_date)
    forecast, sigma = get_forecast(future_date)
    {
      forecast: forecast,
      sigma: sigma,
      best: forecast + sigma,
      worse: forecast - sigma
    }
  end

  def user_stats(from, to)
    {
      best_clients: top_client('revenue desc', from, to),
      worse_clients: top_client('revenue asc', from, to),
      best_subcontractor: best_subcontractor(from, to),
      worse_overdue_client: worse_overdue_client(from, to)
    }
  end

private

  def payouts
    SubcontractorPayout.sum(:amount)
  end

  def gross_sales
    Invoice.sum(:paid_amount)
  end

  def count_jobs(status)
    Job.where(status: status).count.to_f
  end

  def get_forecast(future_date)
    line_fit = LineFit.new
    days, revenues = sum_revenue_by_day
    line_fit.setData(days, revenues)
    forecast = line_fit.forecast(future_date.to_date.mjd) - revenues.last
    sigma = line_fit.sigma
    [forecast, sigma]
  end

  def sum_revenue_by_day
    @revenue_by_day ||= Job.joins(:invoice, :subcontractor_payout)
      .select('end_date, sum(amount) - sum(paid_amount) as revenue')
      .group(:end_date)
      .order(:end_date)
    days = []
    revenues = []
    sum_revenue = 0
    @revenue_by_day.each do |day|
      sum_revenue += day.revenue
      days << day.end_date.mjd
      revenues << sum_revenue
    end
    [days, revenues]
  end

  def top_client(order, from, to)
    Client.joins(jobs: [:invoice, :subcontractor_payout])
      .where(jobs: {end_date: from..to})
      .group('jobs.client_id')
      .select('clients.*, sum(amount) - sum(paid_amount) as revenue')
      .order(order)
      .limit(5)
  end

  def best_subcontractor(from, to)
    Subcontractor.joins(jobs: [:invoice, :subcontractor_payout])
      .select('subcontractors.*, sum(amount) - sum(paid_amount) as revenue')
      .where(jobs: {end_date: from..to})
      .group('jobs.subcontractor_id')
      .order('revenue desc')
      .first
  end

  def worse_overdue_client(from, to)
    Client.joins(jobs: :invoice)
      .select('clients.*, sum(julianday(CURRENT_DATE) - julianday(jobs.end_date)) as overdue')
      .where(jobs: {end_date: from..to}, invoices: {status: :overdue})
      .group('invoices.client_id')
      .order('overdue desc')
      .first
  end

end

