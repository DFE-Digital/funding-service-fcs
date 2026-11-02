namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System;
    using System.Collections.Generic;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public static class CrmOptionSetFactory
    {
        private static readonly IDictionary<string, OptionSetValue> FundingStreamPaymentTypes = new Dictionary<string, OptionSetValue>();
        private static readonly IDictionary<string, OptionSetValue> PaymentCappingLevels = new Dictionary<string, OptionSetValue>();
        private static readonly IDictionary<string, OptionSetValue> PaymentCappingPeriods = new Dictionary<string, OptionSetValue>();
        private static readonly IDictionary<string, OptionSetValue> CappingGroups = new Dictionary<string, OptionSetValue>();
        private static readonly IDictionary<string, OptionSetValue> ContractNumberType = new Dictionary<string, OptionSetValue>();

        static CrmOptionSetFactory()
        {
            FundingStreamPaymentTypes.Add("PAYONACTUALS", new OptionSetValue((int)sfa_fundingstreampaymenttype.PayOnActuals));
            FundingStreamPaymentTypes.Add("PAYONPROFILE", new OptionSetValue((int)sfa_fundingstreampaymenttype.PayOnProfile));
            FundingStreamPaymentTypes.Add("PAIDEXTERNALLY", new OptionSetValue((int)sfa_fundingstreampaymenttype.NotPaid));
            FundingStreamPaymentTypes.Add("PAYONINSTRUCTION", new OptionSetValue((int)sfa_fundingstreampaymenttype.PayOnInstruction));
            FundingStreamPaymentTypes.Add("NOTCALCULATEDORPAID", new OptionSetValue((int)sfa_fundingstreampaymenttype.NoCalcAndNoPay));

            PaymentCappingLevels.Add("DELIVERABLEGROUP", new OptionSetValue((int)sfa_paymentcappinglevel.Group));
            PaymentCappingLevels.Add("DELIVERABLELINE", new OptionSetValue((int)sfa_paymentcappinglevel.DeliverableLine));
            PaymentCappingLevels.Add("CONTRACTALLOCATION", new OptionSetValue((int)sfa_paymentcappinglevel.ContractAllocation));

            PaymentCappingPeriods.Add("ACADEMICYEAR", new OptionSetValue((int)sfa_paymentcappingperiod.AcademicYear));
            PaymentCappingPeriods.Add("CONTRACTALLOCATIONDURATION", new OptionSetValue((int)sfa_paymentcappingperiod.DurationFY));
            PaymentCappingPeriods.Add("FINANCIALYEAR", new OptionSetValue((int)sfa_paymentcappingperiod.FinancialYear));
            PaymentCappingPeriods.Add("ACADEMICANDFINANCIALYEAR", new OptionSetValue((int)sfa_paymentcappingperiod.AcademicAndFinancialYear));

            CappingGroups.Add("APPRENTICESHIPS", new OptionSetValue((int)sfa_cappinggroup.Apprenticeships));
            CappingGroups.Add("NONAPPRENTICESHIPS", new OptionSetValue((int)sfa_cappinggroup.NonApprenticeships));
            CappingGroups.Add("OTHERASB", new OptionSetValue((int)sfa_cappinggroup.OtherASB));
            CappingGroups.Add("NOTAPPLICABLE", new OptionSetValue((int)sfa_cappinggroup.NotApplicable));
            CappingGroups.Add("CUSTOMERSATISFACTION", new OptionSetValue((int)sfa_cappinggroup.CustomerSatisfaction));
            CappingGroups.Add("OTHERINCUSTODY", new OptionSetValue((int)sfa_cappinggroup.OtherInCustody));
            CappingGroups.Add("OTHERINTHECOMMUNITY", new OptionSetValue((int)sfa_cappinggroup.OtherIntheCommunity));
            CappingGroups.Add("SHORTTERMFUNDINGINITIATIVE1", new OptionSetValue((int)sfa_cappinggroup.ShortTermFundingInitiative1));
            CappingGroups.Add("SHORTTERMFUNDINGINITIATIVE2", new OptionSetValue((int)sfa_cappinggroup.ShortTermFundingInitiative2));
            CappingGroups.Add("SHORTTERMFUNDINGINITIATIVE3", new OptionSetValue((int)sfa_cappinggroup.ShortTermFundingInitiative3));
            CappingGroups.Add("SHORTTERMFUNDINGINITIATIVE4", new OptionSetValue((int)sfa_cappinggroup.ShortTermFundingInitiative4));

            ContractNumberType.Add("MASTER", new OptionSetValue((int)sfa_contractnumber_sfa_contractnumbertype.Master));
            ContractNumberType.Add("CONTRACT", new OptionSetValue((int)sfa_contractnumber_sfa_contractnumbertype.Contract));
            ContractNumberType.Add("ALLOCATION", new OptionSetValue((int)sfa_contractnumber_sfa_contractnumbertype.Allocation));
        }

        public static OptionSetValue CreateFundingStreamPaymentTypeFromString(string paymentType)
        {
            if (!string.IsNullOrEmpty(paymentType))
            {
                string formattedPaymentType = paymentType.Replace(" ", String.Empty).ToUpper();
                if (FundingStreamPaymentTypes.ContainsKey(formattedPaymentType))
                {
                    return FundingStreamPaymentTypes[formattedPaymentType];
                }
            }

            throw new ArgumentException($"This payment type is not expected - {paymentType}");
        }

        public static OptionSetValue CreatePaymentCappingLevelFromString(string paymentCappingLevel)
        {
            OptionSetValue foundOptionSetValue = null;
            if (!string.IsNullOrEmpty(paymentCappingLevel))
            {
                string formattedPaymentType = paymentCappingLevel.Replace(" ", String.Empty).ToUpper();
                if (PaymentCappingLevels.ContainsKey(formattedPaymentType))
                {
                    foundOptionSetValue = PaymentCappingLevels[formattedPaymentType];
                }
                else
                {
                    throw new ArgumentException($"This payment type is not expected - {paymentCappingLevel}");
                }
            }

            return foundOptionSetValue;
        }

        public static OptionSetValue CreatePaymentCappingPeriodFromString(string paymentCappingPeriod)
        {
            OptionSetValue foundOptionSetValue = null;
            if (!string.IsNullOrEmpty(paymentCappingPeriod))
            {
                string formattedValue = paymentCappingPeriod.Replace(" ", String.Empty).ToUpper();
                if (PaymentCappingPeriods.ContainsKey(formattedValue))
                {
                    foundOptionSetValue = PaymentCappingPeriods[formattedValue];
                }
                else
                {
                    throw new ArgumentException($"This payment capping is not expected - {formattedValue}");
                }
            }

            return foundOptionSetValue;
        }

        public static OptionSetValue CreateCappingGroupFromString(string cappingGroup)
        {
            OptionSetValue cappingGroupSetValue = null;
            if (!string.IsNullOrEmpty(cappingGroup))
            {
                string formattedValue = cappingGroup.Replace(" ", String.Empty).Replace("-", String.Empty).ToUpper();
                if (CappingGroups.ContainsKey(formattedValue))
                {
                    cappingGroupSetValue = CappingGroups[formattedValue];
                }
                else
                {
                    throw new ArgumentException($"This capping group is not expected - {formattedValue}");
                }
            }

            return cappingGroupSetValue;
        }

        public static OptionSetValue CreateContractNumberType(string contractNumberType)
        {
            OptionSetValue contractNumberTypeSetValue = null;
            if (!string.IsNullOrEmpty(contractNumberType))
            {
                string formattedValue = contractNumberType.Replace(" ", String.Empty).Replace("-", String.Empty).ToUpper();
                if (ContractNumberType.ContainsKey(formattedValue))
                {
                    contractNumberTypeSetValue = ContractNumberType[formattedValue];
                }
                else
                {
                    throw new ArgumentException($"This contract number type is not expected - {formattedValue}");
                }
            }

            return contractNumberTypeSetValue;
        }
    }
}
