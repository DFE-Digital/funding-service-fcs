namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public class FundingStreamPeriod
    {
        [Key]
        [StringLength(20)]
        public string Code { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        [Required]
        public bool ProcessFutureActuals { get; set; }

        [Required]
        public bool PersistCurrentActualsState { get; set; }

        [Required]
        public bool ZeroiseMissingActuals { get; set; }

        [Required]
        public FundingStreamPeriodPaymentMethod PaymentMethod { get; set; }

        public DateTime? ActivityCloseDate { get; set; }

        [Required]
        public bool MultiCollectionReturns { get; set; }

        public FundingStreamZeroisationBehaviour GetZeroisationBehaviour()
        {
            Guard(() => ProcessFutureActuals && PersistCurrentActualsState,
                $"We do not support both {nameof(ProcessFutureActuals)} and {nameof(PersistCurrentActualsState)}");

            Guard(() => !ZeroiseMissingActuals && (ProcessFutureActuals || PersistCurrentActualsState),
                $"{nameof(ProcessFutureActuals)} or {nameof(PersistCurrentActualsState)} cannot be true if {nameof(ZeroiseMissingActuals)} is false");

            FundingStreamZeroisationBehaviour behaviour = FundingStreamZeroisationBehaviour.NotSet;
            if (ProcessFutureActuals)
            {
                behaviour = FundingStreamZeroisationBehaviour.ProcessFutureActuals;
            }
            else if (PersistCurrentActualsState)
            {
                behaviour = FundingStreamZeroisationBehaviour.PersistCurrentViewActualsState;
            }
            else if (ZeroiseMissingActuals)
            {
                behaviour = FundingStreamZeroisationBehaviour.ZeroiseMissingActuals;
            }

            return behaviour;
        }

        public bool IsFspActive(DateTime currentDate)
        {
            return ActivityCloseDate == null || ActivityCloseDate > currentDate;
        }

        private void Guard(Func<bool> hasError, string errorMessage)
        {
            if (hasError())
            {
                throw new ArgumentException(errorMessage);
            }
        } 
    }
}
