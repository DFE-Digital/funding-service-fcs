namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System.Collections.Generic;
    using Implementation.Entities;

    public class LookupCriteria
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="LookupCriteria" /> class.
        /// </summary>
        public LookupCriteria()
        {
            FundingTypes = new HashSet<string>();
            ContractTypes = new HashSet<string>();
            OwningBusinessUnits = new HashSet<string>();
            NextActions = new HashSet<string>();
            OwningTeams = new HashSet<string>();
            OwningUsers = new HashSet<string>();
            LastWorkflowHistories = new HashSet<string>();
            UkPrns = new HashSet<string>();
            Users = new HashSet<string>();
            SubStatus = new HashSet<string>();
            CurrentTasks = new HashSet<string>();

            // the pk is made up of more than one field
            Periods = new HashSet<CrmCompositeKey>();
            FundingStreams = new HashSet<string>();

            // these are special as the PK is made up of more than one field
            FundingStreamPeriods = new HashSet<CrmCompositeKey>();
            PeriodTypeType = new HashSet<string>();
            UnitsOfProcurement = new HashSet<string>();
            LEP = new HashSet<string>();
            CorrelationId = new HashSet<string>();
        }

        public HashSet<string> FundingTypes { get; set; }

        public HashSet<string> ContractTypes { get; set; }

        public HashSet<string> OwningBusinessUnits { get; set; }

        public HashSet<string> NextActions { get; set; }

        public HashSet<string> OwningTeams { get; set; }

        public HashSet<string> OwningUsers { get; set; }

        public HashSet<string> LastWorkflowHistories { get; set; }

        public HashSet<string> UkPrns { get; set; }

        public HashSet<string> Users { get; set; }

        public HashSet<string> SubStatus { get; set; }

        public HashSet<string> CurrentTasks { get; set; }

        public HashSet<CrmCompositeKey> Periods { get; set; }

        public HashSet<string> FundingStreams { get; set; }

        public HashSet<CrmCompositeKey> FundingStreamPeriods { get; set; }

        public HashSet<string> PeriodTypeType { get; set; }

        public HashSet<string> UnitsOfProcurement { get; set; }

        public HashSet<string> LEP { get; set; }

        public HashSet<string> CorrelationId { get; set; }
    }
}