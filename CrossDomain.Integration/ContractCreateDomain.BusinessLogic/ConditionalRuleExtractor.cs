namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using Validation;
    using Validation.Rules;
    using CrossDomain.Integration.Entities.ContractRequest;

    public static class ConditionalRuleExtractor
    {
        public static List<IRule<contractRequestType>> CreateConditionalRules(contractRequestType contractRequest)
        {
            List<IRule<contractRequestType>> rules = new List<IRule<contractRequestType>>();

            foreach (ConditionalDataItem conditionalDataItem in ConditionalDataItems.ConditionalArguments.Where(c => c.ErrorLevel == errorInfoTypeLevel.MasterContract))
            {
                object switchData = GetSwitchData(
                    conditionalDataItem,
                    () => GetDataValue(contractRequest.contract, conditionalDataItem.ConditionalSwitchItem),
                    contractRequest.contract.fundingTypeCode);

                PropertyExtractor extractor = new PropertyExtractor(contractRequest.contract, conditionalDataItem.PropertyName, switchData, conditionalDataItem.MatchedValues, conditionalDataItem.ShouldMatchValues);
                rules.Add(new ConditionalMandatoryFieldsRule(conditionalDataItem, extractor, errorInfoTypeLevel.MasterContract));
            }

            foreach (var contract in contractRequest.contract.contracts)
            {
                foreach (ConditionalDataItem conditionalDataItem in ConditionalDataItems.ConditionalArguments.Where(c => c.ErrorLevel == errorInfoTypeLevel.Contract))
                {
                    object switchData = GetSwitchData(
                        conditionalDataItem,
                        () => GetDataValue(contract, conditionalDataItem.ConditionalSwitchItem),
                        contractRequest.contract.fundingTypeCode);

                    PropertyExtractor extractor = new PropertyExtractor(contract, conditionalDataItem.PropertyName, switchData, conditionalDataItem.MatchedValues, conditionalDataItem.ShouldMatchValues);
                    rules.Add(new ConditionalMandatoryFieldsRule(conditionalDataItem, extractor, errorInfoTypeLevel.Contract));
                }

                foreach (var allocation in contract.contractAllocations)
                {
                    foreach (ConditionalDataItem conditionalDataItem in ConditionalDataItems.ConditionalArguments.Where(c => c.ErrorLevel == errorInfoTypeLevel.Allocation))
                    {
                        object switchData = GetSwitchData(
                            conditionalDataItem,
                            delegate()
                            {
                                return GetDataValue(allocation, conditionalDataItem.ConditionalSwitchItem);
                            },
                            contractRequest.contract.fundingTypeCode);

                        PropertyExtractor extractor = new PropertyExtractor(allocation, conditionalDataItem.PropertyName, switchData, conditionalDataItem.MatchedValues, conditionalDataItem.ShouldMatchValues);

                        rules.Add(new ConditionalMandatoryFieldsRule(conditionalDataItem, extractor,
                            errorInfoTypeLevel.Allocation));
                    }
                }
            }

            return rules;
        }

        private static object GetSwitchData(ConditionalDataItem conditionalDataItem, Func<object> getDataValue, string fundingTypeCode)
        {
            object switchData;
            if (conditionalDataItem.ConditionalSwitchItem == ConditionalDataItems.FundingTypeCode)
            {
                switchData = fundingTypeCode;
            }
            else
            {
                switchData = getDataValue();
            }

            return switchData;
        }

        private static object GetDataValue(object item, string propertyName)
        {
            var data = item;
            PropertyInfo propertyInfo = data.GetType().GetProperty(propertyName);
            if (propertyInfo != null)
            {
                data = propertyInfo.GetValue(data);
            }
            else
            {
                throw new Exception(string.Format("The type - {0} - does not support the property - {1}", data.GetType(), propertyName));
            }

            return data;
        }
    }
}