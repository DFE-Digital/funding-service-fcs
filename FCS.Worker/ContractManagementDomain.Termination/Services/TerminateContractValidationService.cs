namespace ContractManagementDomain.Termination.Services
{
    using ContractManagementDomain.Termination.DTOs;
    using ContractManagementDomain.Termination.Infrastructure;

    public class TerminateContractValidationService : ITerminateContractValidationService
    {
        public Either<RejectionReason, TerminateContractInfo> Validate(TerminateContractInfo terminateContractInfo)
        {
            return new Either<RejectionReason, TerminateContractInfo>(terminateContractInfo)
                .Bind(IsLatest)
                .Bind(IsTerminationDateValid)
                .Bind(HasNoOutStandingPayments)
                .Bind(IsNotDuringMonthEnd);
        }

        private static Either<RejectionReason, TerminateContractInfo> IsLatest(TerminateContractInfo terminateContractInfo)
        {
            if (terminateContractInfo.IsLatest)
            {
                return terminateContractInfo;
            }

            return new RejectionReason("a draft amendment exists", RejectionReason.Why.IsNotLatest);
        }

        private static Either<RejectionReason, TerminateContractInfo> IsTerminationDateValid(TerminateContractInfo terminateContractInfo)
        {
            if (terminateContractInfo.ContractTerminationDate < terminateContractInfo.CurrentDate.Date)
            {
                return terminateContractInfo;
            }

            return new RejectionReason("Contract Termination Date must be in the past", RejectionReason.Why.TerminationDateIsNotValid);
        }

        private static Either<RejectionReason, TerminateContractInfo> HasNoOutStandingPayments(TerminateContractInfo terminateContractInfo)
        {
            if (!terminateContractInfo.HasOutStandingPayments(terminateContractInfo.ContractIdentifier))
            {
                return terminateContractInfo;
            }

            return new RejectionReason("outstanding payments exist", RejectionReason.Why.HasOutstandingPayments);
        }

        private static Either<RejectionReason, TerminateContractInfo> IsNotDuringMonthEnd(TerminateContractInfo terminateContractInfo)
        {
            if (!terminateContractInfo.IsMonthEndRunning())
            {
                return terminateContractInfo;
            }

            return new RejectionReason("month-end processing is in progress - please try again later", RejectionReason.Why.DuringMonthEnd);
        }
    }
}
