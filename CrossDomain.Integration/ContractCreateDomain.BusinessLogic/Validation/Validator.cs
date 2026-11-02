namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using System.Configuration;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Framework.Logging.Interfaces;

    public class Validator : IValidator
    {
        public ILogger Logger { get; set; }

        public bool Validate(contractRequestType contractRequest, IEnumerable<IRule<contractRequestType>> rules)
        {
            // Contract Request type contains a contract (represents the master contract)
            // This contracts properties contains a list child contracts
            // The contract request will only ever impact one child at a child so we can assert that this structure only never contains one child
            AssertContractRequestTypeStructure(contractRequest);

            string overrideValidationSetting = ConfigurationManager.AppSettings["ContractCreateDomain.Validate"];
            if (!string.IsNullOrEmpty(overrideValidationSetting))
            {
                if (overrideValidationSetting.ToLower() == "false")
                {
                    return true;
                }
            }

            var ruleFailed = false;
            foreach (var rule in rules)
            {
                // Catch all exceptions within a validation rule and log a validation failure error message
                try
                {
                    var failures = rule.GetFailuresForItem(contractRequest).ToList();

                    if (failures.Any())
                    {
                        AddFailuresToErrorInfo(failures, rule, contractRequest);
                        ruleFailed = true;
                    }
                }
                catch (Exception e)
                {
                    Logger.LogInformation(e, "Error occurred when trying to validate " + rule + ". Adding validation failure error message.");

                    AddValidationFailureToErrorInfo(rule.ErrorLevel, contractRequest);
                    ruleFailed = true;
                }
            }

            return !ruleFailed;
        }

        private void AssertContractRequestTypeStructure(contractRequestType contractRequest)
        {
            if (contractRequest.contract == null)
            {
                //Logger.LogInformation(ContractDocumentMergeFailedContractNull, $"{nameof(ContractDocumentManager)} merge failed, Contract is null");
                throw new InvalidOperationException("Validator.Validate called with no master contract.");
            }

            if (contractRequest.contract.contracts.Count == 0)
            {
                //Logger.LogInformation(ContractDocumentMergeFailedContractNull, $"{nameof(ContractDocumentManager)} merge failed, Contract has no child contracts");
                throw new InvalidOperationException("Validator.Validate called with no child contracts.");
            }

            if (contractRequest.contract.hierarchyType!= hierarchyType.MASTERCONTRACT)
            {
                throw new InvalidOperationException("ContractDocumentManager.MergeContractDocuments called with child contract.");
            }
        }

        public void InitializeErrorIfo(contractRequestType contract)
        {
            if (contract.errorInfo == null)
            {
                contract.errorInfo = new List<errorInfoType>();
            }
        }

        private static void AddValidationFailureToErrorInfo(errorInfoTypeLevel errorLevel, contractRequestType contract)
        {
            // User friendly error message
            var itemDescription = "item(s)";
            switch (errorLevel)
            {
                case errorInfoTypeLevel.MasterContract:
                    itemDescription = "Master Contract(s)";
                    break;
                case errorInfoTypeLevel.Contract:
                    itemDescription = "Contract(s)";
                    break;
                case errorInfoTypeLevel.Allocation:
                    itemDescription = "Contract Allocation(s)";
                    break;
                case errorInfoTypeLevel.Deliverable:
                    itemDescription = "Contract Deliverable(s)";
                    break;
                case errorInfoTypeLevel.DeliverablePeriod:
                    itemDescription = "Contract Deliverable Period(s)";
                    break;
            }

            // Add error message at Contract level
            foreach (var childContract in contract.contract.contracts)
            {
                if (contract.errorInfo == null)
                {
                    contract.errorInfo = new List<errorInfoType>();
                }

                contract.errorInfo.Add(new errorInfoType
                {
                    correlationId = childContract.correlationId,
                    level = errorLevel,
                    Value = string.Format("One or more {0} could not be validated.", itemDescription)
                });
            }
        }

        private static void AddErrorMsgToErrorList(contractRequestType contract, string correlationId, IRule<contractRequestType> rule)
        {
            contract.errorInfo.Add(new errorInfoType
            {
                correlationId = correlationId,
                level = rule.ErrorLevel,
                Value = rule.ErrorMessage,
                Severity = GetSeverity(rule)
            });
        }

        private static ErrorSeverity GetSeverity(IRule<contractRequestType> rule)
        {
            if (rule is ISevereRule<contractRequestType>)
            {
                return ErrorSeverity.Severe;
            }
            
            return ErrorSeverity.Standard;
        }


        private void AddFailuresToErrorInfo(IEnumerable<string> failures, IRule<contractRequestType> rule, contractRequestType contract)
        {
            InitializeErrorIfo(contract);

            foreach (var failure in failures)
            {
                AddErrorMsgToErrorList(contract, failure, rule);
            }
        }
    }
}