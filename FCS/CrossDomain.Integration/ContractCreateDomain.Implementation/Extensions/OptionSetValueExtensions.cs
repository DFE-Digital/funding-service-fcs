namespace SFA.FCT.ContractCreateDomain.Implementation.Extensions
{
    using System;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk;

    public static class OptionSetValueExtensions
    {
        public static string GetNewStartSuspendedReasonText(this OptionSetValue optionSetValue)
        {
            if (optionSetValue != null)
            {
                if (!Enum.IsDefined(typeof(sfa_newstartssuspendedreason), optionSetValue.Value))
                {
                    throw new ArgumentOutOfRangeException(
                        $"The option set value: {optionSetValue.Value} is not a sfa_newstartssuspendedreason");
                }

                var rawEnumString = ((sfa_newstartssuspendedreason) optionSetValue.Value).ToString();
                if (rawEnumString == "RemovedfromRoATP")
                {
                    return "Removed from RoATP";
                }

                return rawEnumString.ToTextWithSpaceBeforeCapitals();
            }

            return null;
        }

        public static string GetText<T>(this OptionSetValue optionSetValue) where T : Enum
        {
            if (optionSetValue != null)
            {
                if (!Enum.IsDefined(typeof(T), optionSetValue.Value))
                {
                    throw new ArgumentOutOfRangeException(
                        $"The option set value: {optionSetValue.Value} is not a {typeof(T).Name}");
                }

                var rawEnumString = ((T)(object)optionSetValue.Value).ToString();

                return rawEnumString;
            }

            return null;
        }
    }
}