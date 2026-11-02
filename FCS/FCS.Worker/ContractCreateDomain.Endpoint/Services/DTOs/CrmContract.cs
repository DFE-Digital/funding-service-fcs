namespace ContractCreateDomain.Endpoint.Services.DTOs
{
    using System;
    using System.Collections.Generic;

    public class CrmContract
    {
        public CrmContract(string number, IReadOnlyCollection<CrmAllocation> allocations)
        {
            Number = number;
            Allocations = allocations;
        }

        public string Number { get; set; }

        public IReadOnlyCollection<CrmAllocation> Allocations { get; }
    }

    public class CrmAllocation
    {
        public CrmAllocation(string number, DateTime? startDate, DateTime? endDate, IReadOnlyCollection<CrmDeliverable> deliverables)
        {
            Number = number;
            StartDate = startDate;
            EndDate = endDate;
            Deliverables = deliverables;
        }

        public string Number { get; }

        public DateTime? StartDate { get; }

        public DateTime? EndDate { get; }

        public IReadOnlyCollection<CrmDeliverable> Deliverables { get; }
    }

    public class CrmDeliverable
    {
        public CrmDeliverable(string code, IReadOnlyCollection<CrmDeliverablePeriod> periods)
        {
            Code = code;
            Periods = periods;
        }

        public string Code { get; }

        public int CodeAsNumber => int.Parse(Code);

        public IReadOnlyCollection<CrmDeliverablePeriod> Periods { get; }
    }

    public class CrmDeliverablePeriod
    {
        public CrmDeliverablePeriod(int period, string periodName, decimal? plannedValue, int year)
        {
            Period = period;
            PeriodName = periodName;
            PlannedValue = plannedValue;
            Year = year;
        }

        public int Period { get; }

        public string PeriodName { get; }

        public int Year { get; }

        public decimal? PlannedValue { get; }
    }
}
