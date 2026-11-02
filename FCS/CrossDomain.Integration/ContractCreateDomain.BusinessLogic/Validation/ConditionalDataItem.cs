namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class ConditionalDataItem
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="propertyName">The name of the property</param>
        /// <param name="conditionalSwitchItem"></param>
        /// <param name="matchedValues">The list of values which the conditionalSwitchItem must be in in order for us to run the rule</param>
        /// <param name="shouldBeNull">Is true it the prop value should be null</param>
        /// <param name="errorLevel">The error level</param>
        public ConditionalDataItem(string propertyName, string conditionalSwitchItem, List<object> matchedValues, bool shouldBeNull, errorInfoTypeLevel errorLevel)
        {
            PropertyName = propertyName;
            ConditionalSwitchItem = conditionalSwitchItem;
            MatchedValues = matchedValues;
            ShouldBeNull = shouldBeNull;
            ErrorLevel = errorLevel;
            ShouldMatchValues = true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="propertyName">The name of the property</param>
        /// <param name="conditionalSwitchItem"></param>
        /// <param name="matchedValues">The list of values which the conditionalSwitchItem must be in or not in in order for us to run the rule</param>
        /// <param name="shouldBeNull">Is true it the prop value should be null</param>
        /// <param name="errorLevel">The error level</param>
        /// <param name="shouldMatchValues">Is true the counditionalSwitchItem must not be in matchedValues</param>
        public ConditionalDataItem(string propertyName, string conditionalSwitchItem, List<object> matchedValues, bool shouldBeNull, errorInfoTypeLevel errorLevel, bool shouldMatchValues)
        {
            PropertyName = propertyName;
            ConditionalSwitchItem = conditionalSwitchItem;
            MatchedValues = matchedValues;
            ShouldBeNull = shouldBeNull;
            ErrorLevel = errorLevel;
            ShouldMatchValues = shouldMatchValues;
        }

        public string PropertyName { get; private set; }

        public errorInfoTypeLevel ErrorLevel { get; private set; }

        public string ConditionalSwitchItem { get; private set; }

        public List<object> MatchedValues { get; private set; }

        public bool ShouldBeNull { get; private set; }

        public bool ShouldMatchValues { get; private set; }
    }
}
