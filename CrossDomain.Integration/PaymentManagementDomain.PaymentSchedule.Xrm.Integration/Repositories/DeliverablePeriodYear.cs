namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories
{
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using CrossDomain.Integration.Entities.Xrm;

    public class DeliverablePeriodYear
    {
        public DeliverablePeriodYear(int? period, string periodName, int? year, string deliverableCode, sfa_contractdeliverableperiod deliverablePeriod)
        {
            Period = period;
            PeriodName = periodName;
            Year = year;
            DeliverableCode = deliverableCode;
            CrmDeliverablePeriod = deliverablePeriod;
        }

        public DeliverablePeriodYear(int? period, string periodName, int? year, string deliverableCode)
        {
            Period = period;
            PeriodName = periodName;
            Year = year;
            DeliverableCode = deliverableCode;
        }

        public DeliverablePeriodYear(int? period, string periodName, int? year, string deliverableCode, ScheduledPayment scheduledPayment) 
            : this(period, periodName, year, deliverableCode)
        {
            ScheduledPayment = scheduledPayment;
        }

        public int? Period { get; }

        public string PeriodName { get; }

        public int? Year { get; }

        public string DeliverableCode { get; }

        public int DeliverableCodeInt => int.Parse(DeliverableCode);

        public sfa_contractdeliverableperiod CrmDeliverablePeriod { get; }

        public ScheduledPayment ScheduledPayment { get; }

        public override bool Equals(object obj)
        {
            bool isEqual = false;
            DeliverablePeriodYear other = obj as DeliverablePeriodYear;
            if (other != null)
            {
                isEqual = other.Period == Period && other.Year == Year && other.DeliverableCode == DeliverableCode;
            }

            return isEqual;
        }

        public override int GetHashCode()
        {
            return Period.GetHashCode() ^ Year.GetHashCode() ^ DeliverableCode.GetHashCode();
        }
    }
}
