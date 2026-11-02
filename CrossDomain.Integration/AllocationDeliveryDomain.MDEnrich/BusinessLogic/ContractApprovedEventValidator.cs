
namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic
{
    using CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;
    using System;


    public class ContractApprovedEventValidationResult
    {
        public string ContextMessage { get; set; }
   
        public bool Result { get; set; }
    }

    public class ContractApprovedEventValidator
    {
        public static ContractApprovedEventValidationResult Validate(ContractApprovedEvent message)
        {
            if (message.CorporateContract == null)
            {                
                return new ContractApprovedEventValidationResult
                {
                    Result = false,
                    ContextMessage = "ContractApprovedEvent passed to ContractApprovedHandler.Handle has no master contract."
                };
            }

            if (message.CorporateContract.contracts.Count == 0)
            {
                return new ContractApprovedEventValidationResult
                {
                    Result = false,
                    ContextMessage = "ContractApprovedEvent passed to ContractApprovedHandler.Handle has no child contracts."
                };
            }

            if (message.CorporateContract.hierarchyType != hierarchyType.MASTERCONTRACT)
            {
                 return new ContractApprovedEventValidationResult
                {
                    Result = false,
                    ContextMessage = "ContractApprovedEvent passed to ContractApprovedHandler.Handle is a child contract."
                };
            }

            if (message.CorporateContract.contracts.Count != 1)
            {
                return new ContractApprovedEventValidationResult
                {
                    Result = false,
                    ContextMessage = "ContractApprovedEvent passed to ContractApprovedHandler.Handle has multiple child contract."
                };
            }

            return new ContractApprovedEventValidationResult
            {
                Result = true
            };
        }
    }
}
