namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class PropertyExtractor
    {
        public PropertyExtractor(object dataObject, string propertyName, object switchData, List<object> switchObjects)
        {
            ConditionalMatch = IsConditionalMatch(switchData, switchObjects, true);
            PropertyValue = GetPropertyValue(dataObject, propertyName);
            CorrelationId = GetPropertyCorrelationId(dataObject);
        }

        public PropertyExtractor(object dataObject, string propertyName, object switchData, List<object> switchObjects, bool shouldBeInSwitchObjects)
        {
            ConditionalMatch = IsConditionalMatch(switchData, switchObjects, shouldBeInSwitchObjects);
            PropertyValue = GetPropertyValue(dataObject, propertyName);
            CorrelationId = GetPropertyCorrelationId(dataObject);
        }

        public bool ConditionalMatch { get; set; }

        public object PropertyValue { get; set; }

        public string CorrelationId { get; set; }


        private bool IsConditionalMatch(object valueItem, List<object> values, bool shouldBeInSwitchObjects)
        {
            if (shouldBeInSwitchObjects)
                return values.Contains(valueItem);

            return !values.Contains(valueItem);
        }

        private object GetPropertyValue(object dataObject, string propertyName)
        {
            return dataObject.GetType().GetProperty(propertyName).GetValue(dataObject);
        }

        private string GetPropertyCorrelationId(object o)
        {
            return GetPropertyValue(o, "correlationId")?.ToString() ?? string.Empty;
        }
    }

    /// <summary>
    /// RSR-002. Funding type specific mandatory data items present on each tab
    /// </summary>
    public class ConditionalMandatoryFieldsRule : IRule<contractRequestType>
    {
        private readonly ConditionalDataItem _conditionalData;

        private readonly PropertyExtractor _extractor;

        private readonly errorInfoTypeLevel _errorLevel;

        public ConditionalMandatoryFieldsRule(ConditionalDataItem conditionalData, PropertyExtractor extractor, errorInfoTypeLevel errorLevel)
        {
            _conditionalData = conditionalData;
            _extractor = extractor;
            _errorLevel = errorLevel;
        }

        public string ErrorMessage
        {
            get
            {
                string errorMessage;
                if (!_conditionalData.ShouldMatchValues)
                {
                    errorMessage = ErrorMessages.UnexpectedConditionalItemErrorMessage.Replace(
                        ErrorMessages.ReplaceString,
                        _conditionalData.PropertyName); ;
                }
                else if (_conditionalData.ConditionalSwitchItem == ConditionalDataItems.FundingTypeCode ||
                    _conditionalData.ConditionalSwitchItem == ConditionalDataItems.FundingStreamCode)
                {
                    errorMessage = ErrorMessages.ConditionalMandatoryItemMissingErrorMessage.Replace(
                        ErrorMessages.ReplaceString,
                        _conditionalData.PropertyName);
                }
                else
                {
                    errorMessage = ErrorMessages.MandatoryItemMissingErrorMessage.Replace(
                        ErrorMessages.ReplaceString,
                        _conditionalData.PropertyName);
                }

                return errorMessage;
            }
        }

        public errorInfoTypeLevel ErrorLevel => _errorLevel;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            IList<string> correlationIds = new List<string>();
            
            if (_extractor.ConditionalMatch && (_extractor.PropertyValue == null) != _conditionalData.ShouldBeNull)
            {
                correlationIds.Add(_extractor.CorrelationId);
            }

            return correlationIds;
        }
    }
}