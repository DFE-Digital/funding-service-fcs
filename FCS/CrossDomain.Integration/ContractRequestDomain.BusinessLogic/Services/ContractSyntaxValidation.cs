namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using DataStore.Repositories;
    using Framework.Logging.Interfaces;
    using Interfaces;
    using MoreLinq;
    using Utils;
    using Validation;

    /// <summary>
    /// Rules covered by the following validation:
    /// Rule CBR-003, DBR-001, DRB-008, RSR-003b, CBR-014
    /// </summary>
    public class ContractSyntaxValidation : IContractSyntaxValidation
    {
        private readonly List<errorInfo> _errors = new List<errorInfo>();
        private readonly IContractSyntaxBusinessRuleService _contractSyntaxBusinessRuleService;
        private readonly IFundingTypeFundingPeriodRepository _fundingTypeFundingPeriodRepository;

        public ContractSyntaxValidation(IContractSyntaxBusinessRuleService contractSyntaxBusinessRuleService, IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository)
        {
            _contractSyntaxBusinessRuleService = contractSyntaxBusinessRuleService;
            _fundingTypeFundingPeriodRepository = fundingTypeFundingPeriodRepository;
        }

        public IReadOnlyCollection<errorInfo> Errors
        {
            get { return _errors; }
        }

        public void Enrich(dataLoadResults dataLoadResults)
        {
            ValidateFile(dataLoadResults);   
        }

        public bool ValidateFile(dataLoadResults file)
        {
            ContractBulkUpload validationFile = new ContractBulkUpload(file);

            foreach (var worksheet in validationFile.BaseClass.workbook)
            {
                var mandatoryItems = DataItems.ContractDataItems.Where(di => di.DataSheet == worksheet.name && di.Mandatory).ToArray();
                var itemsToValidate = DataItems.ContractDataItems.Where(di => di.DataSheet == worksheet.name).ToArray();

                foreach (var row in worksheet.row)
                {
                    ValidateManditoryItems(worksheet.name, row, mandatoryItems);
                    ValidateDataTypesAndLength(worksheet.name, row, itemsToValidate);
                    ValidateDates(worksheet.name, row);
                }
            }

            string fundingTypeCode = DataLoadResultsHelper.GetFundingType(file);
            string fundingPeriod = DataLoadResultsHelper.GetFundingPeriod(file);

            if (_contractSyntaxBusinessRuleService.ShouldFundingTypePreventContractsWithTheSameUkprnForNewOrNewAmendmentIntent(fundingTypeCode))
            {
                _errors.AddRange(DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule.GetFailuresForItem(file));
            }
            else
            {
                _errors.AddRange(DuplicateContractsForASingleUkprnRule.GetFailuresForItem(file));
            }

            GetGeneralFileRules(fundingPeriod: fundingPeriod, fundingTypeCode: fundingTypeCode).ForEach(ruleSet => AddErrorsUntilARuleFails(ruleSet, file));
            
            // Done so we do not loose any pre existing errors.
            if (file.error != null)
            {
                _errors.AddRange(file.error);
            }

            file.error = _errors.ToArray();

            return !_errors.Any();
        }

        private void AddErrorsUntilARuleFails(IEnumerable<AbstractFileRule> ruleSet, dataLoadResults file)
        {
            foreach (var rule in ruleSet)
            {
                if (rule.RunIfErrorsHaveAlreadyOccured || !_errors.Any())
                {
                    IEnumerable<errorInfo> errorsForRule = rule.GetFailuresForItem(file);
                    _errors.AddRange(errorsForRule);
                    if (errorsForRule.Any())
                    {
                        break;
                    }
                }
            }
        }

        private IReadOnlyCollection<IReadOnlyCollection<AbstractFileRule>> GetGeneralFileRules(string fundingPeriod, string fundingTypeCode)
        {
            bool isAllowedToHaveDeliveryOrganisation = _fundingTypeFundingPeriodRepository.IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(
                fundingTypeCode: fundingTypeCode, fundingPeriodName: fundingPeriod);

            return new List<List<AbstractFileRule>>
            {
                new List<AbstractFileRule> { new DeliverablePeriodCrmIntentMustMatch() },
                new List<AbstractFileRule> { new DeliverablePeriodDeliverableDescriptionMustMatch() },
                new List<AbstractFileRule>
                { new DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule(
                    isAllowedToHaveDeliveryOrganisation: isAllowedToHaveDeliveryOrganisation,
                    fundingPeriod: fundingPeriod,
                    fundingTypeCode: fundingTypeCode),
                new DeliveryOrgPresentThenAllMustBeSpecifiedRule()
                },
                new List<AbstractFileRule> { new AmendmentMustNotDeleteAllocationOrDeliverable() }
            };
        }

        private void ValidateDates(string workSheetName, rowType row)
        {
            string start, end;
            switch (workSheetName)
            {
                case ContractBulkUpload.ContractsSheetFieldName:
                    start = ContractBulkUpload.ContractStartDate;
                    end = ContractBulkUpload.ContractEndDate;
                    break;
                case ContractBulkUpload.ContractAllocationSheetFieldName:
                    start = ContractBulkUpload.AllocationsStartDate;
                    end = ContractBulkUpload.AllocationsEndDate;
                    break;
                default:
                    return;
            }

            DateTime? startDate  = row.GetCellDateTime(start);
            DateTime? endDate = row.GetCellDateTime(end);

            if (startDate == null || endDate == null)
            {
                return;
            }

            if (endDate < startDate)
            {
                _errors.Add(new errorInfo
                {
                    Value = ErrorMessages.EndDateBeforeStartDateErrorMessage,
                    sheet = row.id,
                    correlationId = row.id,
                    row = row.rowNumber
                });
            }
        }

        private void ValidateManditoryItems(string workSheetName, rowType row, IEnumerable<DataItem> mandatoryItems)
        {
            List<errorInfo> localErrors = new List<errorInfo>();

            foreach (DataItem mandatoryItem in mandatoryItems)
            {
                var item = row.cell.FirstOrDefault(c => c.columnName == mandatoryItem.ColumnName);
                if (item == null)
                {
                    localErrors.Add(new errorInfo
                    {
                        Value = ErrorMessages.MandatoryItemMissingErrorMessage.Replace(ErrorMessages.ReplaceString, mandatoryItem.ColumnName),
                        sheet = workSheetName,
                        row = row.rowNumber,
                        correlationId = row.id
                    });
                }
            }

            if (localErrors.Any())
            {
                _errors.AddRange(localErrors);
            }
        }

        private void ValidateDataTypesAndLength(string workSheetName, rowType row, IEnumerable<DataItem> itemsToValidate)
        {
            foreach (DataItem dataItem in itemsToValidate)
            {
                var item = row.cell.FirstOrDefault(c => c.columnName == dataItem.ColumnName);
                if (item != null)
                {
                    // Data length
                    if (dataItem.DataLength != -1 &&
                        !(dataItem.Mandatory == false && item.Value.Length == 0) &&
                        dataItem.DataLength != item.Value.Length)
                    {
                        _errors.Add(new errorInfo
                        {
                            Value = ErrorMessages.DataLengthInvalidErrorMessage.Replace(
                            ErrorMessages.ReplaceString, dataItem.ColumnName),
                            sheet = workSheetName,
                            row = row.rowNumber,
                            correlationId = row.id
                        });
                    }

                    // Data type validation
                    if (dataItem.DataType != null &&
                        !(dataItem.Mandatory == false && item.Value.Length == 0) &&
                        !CheckDataType(dataItem, item.Value))
                    {
                        _errors.Add(new errorInfo
                        {
                            Value = string.IsNullOrEmpty(dataItem.OverrideErrorMessage)
                                ? ErrorMessages.DataTypeInvalidErrorMessage.Replace(ErrorMessages.ReplaceString, dataItem.ColumnName)
                                : dataItem.OverrideErrorMessage,
                            sheet = workSheetName,
                            row = row.rowNumber,
                            correlationId = row.id
                        });
                    }
                }
            }
        }

        private bool CheckDataType(DataItem dataItem, string dataValue)
        {
            if (dataItem.DataType == typeof(int))
            {
                return IntParseHelper.IsInteger(dataValue);
            }
            else if (dataItem.DataType == typeof(decimal))
            {
                decimal value;
                if (decimal.TryParse(dataValue, out value))
                {
                    return true;
                }
            }
            else if (dataItem.DataType == typeof(DateTime))
            {
                DateTime value;
                if (DateTime.TryParseExact(dataValue, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out value))              
                {
                    return true;
                }
            }
            else if (dataItem.DataType == typeof(string))
            {
                if ((dataItem.DataType == typeof(string) && dataItem.ValidValues != null && dataItem.ValidValues.Contains(dataValue)) || string.IsNullOrEmpty(dataValue))
                {
                    return true;
                }
            }

            return false;
        }
    }
}
