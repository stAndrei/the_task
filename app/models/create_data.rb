class CreateData

  def perform
    [Client, Subcontractor, Job, Invoice, SubcontractorPayout].map(&:delete_all)
    create_clients
    create_subcontractors
    create_jobs
    create_invoices
    create_subcontractor_payouts
  end

  def create_clients
    clients = []
    100_000.times do |i|
      clients << Client.new(
        name: "Client #{i}",
        local_account_amount: rand(1000),
        rate_set_for_the_client: rand(200)
      )
    end
    Client.import(clients)
  end

  def create_subcontractors
    subcontractors = []
    50_000.times do |i|
      subcontractors << Subcontractor.new(
        name: "Subcontractor #{i}",
        rate: rand(100)
      )
    end
    Subcontractor.import(subcontractors)
  end

  def create_jobs
    jobs = []
    client_ids = Client.pluck(:id)
    subcontractor_ids = Subcontractor.pluck(:id)
    80_000.times do |i|
      status = %w(new accepted rejected done).sample
      start_date = Date.new(2014) + rand(365).days
      end_date = status =~ %w(new rejected) ? nil : start_date + rand(60).days + 1
      jobs << Job.new(
        status: status,
        start_date: start_date,
        end_date: end_date,
        client_id: client_ids.sample,
        subcontractor_id: subcontractor_ids.sample,
      )
    end
    Job.import(jobs)
  end

  def create_invoices
    invoices = []
    Job.where(status: %w(accepted done)).preload(:client).each do |job|
      due_amount = (job.end_date - job.start_date) * job.client.rate_set_for_the_client
      status = %w(pending overdue paid).sample
      paid_amount = status == 'paid' ? due_amount + rand((due_amount * 0.1).to_i) - rand((due_amount * 0.1).to_i) : 0
      status = 'pending' if paid_amount < due_amount
      due_amount += job.client.rate_set_for_the_client * rand(20) if status == 'overdue'
      invoices << Invoice.new(
        due_amount: due_amount,
        paid_amount: paid_amount,
        status: status,
        client_id: job.client_id,
        job_id: job.id,
      )
    end
    Invoice.import(invoices)
  end

  def create_subcontractor_payouts
    payouts = []
    Job.where(status: 'done').preload(:subcontractor).each do |job|
      payouts << SubcontractorPayout.new(
        amount: job.subcontractor.rate * (job.end_date - job.start_date),
        subcontractor_id: job.subcontractor_id,
        job_id: job.id
      )
    end
    SubcontractorPayout.import(payouts)
  end

end