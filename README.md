# The Task

This task is to build the fake business model and predict revenue.

------------------------------------------------------------------

# Business model description


### Basic terms

- Company - we are the company
- Client (meaning a set of clients) - the one who pay us money
- Job - Company does some job for a Client using __one__ subcontractor
- Subcontractor (set of subscontractors) - Guys who actually do all the job behind the scenes. Client does not know anything about contractor. Only Company deals with Subcontractor (always 1 Subcontractor for every single Job)

### Basic flow

- One of our clients requests a job
- Job can be accepted or rejected by our Company

### Job accepted scenario:

- Company accepted `start_date` of this job set by Client
- Company starts working on this job starting from requested `start_date`
- Company estimates and sets `end_date` to this Job
- Company sends invoice to the Client
  - Invoice `due_amount` is equal to `rate_set_for_the_client$ * (end_date - start_date).days`
  - Invoice gets `pending` status
  - Client has to pay for this invoice on any date __before__ `end_date`
  - Invoice hasn't been paid in time scenario:
    - Invoice gets status `overdue`
    - On each day after `end_date` we add `rate_set_for_the_client$` amount to the invoice
    - The Client can't request any new job
  - Invoice has been paid in time scenario:
    - Invoice gets status `paid`
    - Client has an ability to add a new job
- Company finds Subcontractor who is not too busy with other jobs: should have less than 3 jobs assigned
- The Subcontractor gets paid once the job assigned to him is done
- The Subcontractor is paid only for number of days he actually worked:
- Amount paid to subcontractor: `subcontractor.rate * (end_date - start_date).days`
- Company can change Job's `end_date`:
  - Invoice `due_amount` should be recalculated accordingly
  - If Client already paid for the Invoice:
    - If `paid_amount > due_amount` then send money to virtual Client's "local" account (stored in our db)
    - If `paid_amount < due_amount` change `invoice_status` back to `pending`
- Client gets discount once they paid for 3 jobs (as regular customer)
- Discount percentage is set in application config `config/application.yml`
- Client may loose discount if one of their invoices is marked as `overdue`

### Job rejected scenario:

- Company rejected Client's request
- Client has to create new job, the one which is rejected is no longer in use

## Finally your task:

Calculate the following values:

### Revenue

Revenue is calculated as `SUM(invoices.paid_amount) - SUM(subcontractor_payouts.amount)`.

### Gross sales

Gross sales is equal to `SUM(invoices.paid_amount)`

### Rejection rate

Percentage of jobs rejected by the Company

### Predicted revenue

Predict revenue for: next month, next year. Take any valid acceptable algorythm.

Also include in report:

- Standard deviation (if possible)
- Worst case / best case revenue

### Per user stats

Calculate for any given period (set by user):

- Top 5 best clients (based on total __revenue__ impact)
- Top 5 worst clients
- Best subcontractor (based on total __revenue__ impact). Think more about this one.

## Required performance

Take 100000 Clients and 50000 working Subcontractors. Performance is acceptable if you feel comfortable with it :)

------------------------------------------------------------------

This app utilizes Framework v0.0.7 and rocks MIT license.

