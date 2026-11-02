namespace SFA.FCT.ContractRequestDomain.Common
{
    using CrossDomain.Integration.Entities.ContractRequest;
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Reflection;
    using System.Xml.Serialization;
    [ExcludeFromCodeCoverage]
    public static class DataItems
    {
        public const string CRMIntentTypeDeleteDraft = "Delete Draft";
        public const string CRMIntentTypeAmendment = "Amendment";
        public const string CRMIntentTypeUpdateDraftAmendment = "Update Draft Amendment";
        public const string CRMIntentTypeNew = "New";
        public const string CRMIntentTypeUpdateDraft = "Update Draft";
        public const string CRMIntentTypeRevisedNew = "Revised New";

        private static readonly List<string> CrmIntentTypes = GetIntentTypes();

        private static readonly List<string> AmendmentTypes = new List<string>
        {
            "Variation",
            "Notification"
        };

        private static List<DataItem> _contractDataItems = new List<DataItem>
        {
            // Control Sheet
            new DataItem(ContractBulkUpload.ControlSheetFundingTypeCode, ContractBulkUpload.ControlSheetFieldName, null, true),
            new DataItem(ContractBulkUpload.ControlSheetPeriodTypeCode, ContractBulkUpload.ControlSheetFieldName, null, true),
            new DataItem(ContractBulkUpload.ControlSheetPeriod, ContractBulkUpload.ControlSheetFieldName, typeof(int), true),

            // Contracts Sheet
            new DataItem(ContractBulkUpload.Ukprn, ContractBulkUpload.ContractsSheetFieldName, typeof(int), true, 8),
            new DataItem(ContractBulkUpload.ContractStartDate, ContractBulkUpload.ContractsSheetFieldName, typeof(DateTime), false, 10),
            new DataItem(ContractBulkUpload.ContractEndDate, ContractBulkUpload.ContractsSheetFieldName, typeof(DateTime), false, 10),
            new DataItem(ContractBulkUpload.CrmIntent, ContractBulkUpload.ContractsSheetFieldName, typeof(string), true, -1, CrmIntentTypes) { OverrideErrorMessage =  ErrorMessages.CRMIntentInvalidErrorMessage },
            new DataItem(ContractBulkUpload.AmendmentType, ContractBulkUpload.ContractsSheetFieldName, typeof(string), false, -1, AmendmentTypes),

            // Allocations Sheet
            new DataItem(ContractBulkUpload.Ukprn, ContractBulkUpload.ContractAllocationSheetFieldName, typeof(int), true, 8),
            new DataItem(ContractBulkUpload.CrmIntent, ContractBulkUpload.ContractAllocationSheetFieldName, typeof(string), true, -1, CrmIntentTypes) { OverrideErrorMessage =  ErrorMessages.CRMIntentInvalidErrorMessage },
            new DataItem(ContractBulkUpload.AllocationsStartDate, ContractBulkUpload.ContractAllocationSheetFieldName, typeof(DateTime), false, 10),
            new DataItem(ContractBulkUpload.AllocationsEndDate, ContractBulkUpload.ContractAllocationSheetFieldName, typeof(DateTime), false, 10),

            // Deliverables Sheet
            new DataItem(ContractBulkUpload.Ukprn, ContractBulkUpload.ContractDeliverableSheetFieldName, typeof(int), true, 8),
            new DataItem(ContractBulkUpload.FundingStreamCode, ContractBulkUpload.ContractDeliverableSheetFieldName, null, true),
            new DataItem(ContractBulkUpload.DeliverableName, ContractBulkUpload.ContractDeliverableSheetFieldName, null, true),
            new DataItem(ContractBulkUpload.Period, ContractBulkUpload.ContractDeliverableSheetFieldName, typeof(int), true),
            new DataItem(ContractBulkUpload.Year, ContractBulkUpload.ContractDeliverableSheetFieldName, typeof(int), true),
            new DataItem(ContractBulkUpload.DeliverableCode, ContractBulkUpload.ContractDeliverableSheetFieldName, typeof(int), true),
            new DataItem(ContractBulkUpload.Value, ContractBulkUpload.ContractDeliverableSheetFieldName, typeof(decimal)),
            new DataItem(ContractBulkUpload.CrmIntent, ContractBulkUpload.ContractDeliverableSheetFieldName, typeof(string), true, -1, CrmIntentTypes) { OverrideErrorMessage =  ErrorMessages.CRMIntentInvalidErrorMessage },
            new DataItem(ContractBulkUpload.Volume, ContractBulkUpload.ContractDeliverableSheetFieldName, typeof(int)) { OverrideErrorMessage = ErrorMessages.VolumeMustBeAWholeNumber }
        };

        public static List<DataItem> ContractDataItems
        {
            get { return _contractDataItems; }
            set { _contractDataItems = value; }
        }

        private static List<string> GetIntentTypes()
        {
            List<string> listOfIntents = new List<string>();
            intent[] values = (intent[])Enum.GetValues(typeof(intent));

            foreach (var value in values)
            {
                listOfIntents.Add(ConvertToString(value));
            }

            return listOfIntents;
        }

        private static string ConvertToString(Enum e)
        {
            // Get the Type of the enum
            Type t = e.GetType();

            // Get the FieldInfo for the member field with the enums name
            FieldInfo info = t.GetField(e.ToString("G"));

            // Check to see if the XmlEnumAttribute is defined on this field
            if (!info.IsDefined(typeof(XmlEnumAttribute), false))
            {
                // If no XmlEnumAttribute then return the string version of the enum.
                return e.ToString("G");
            }

            // Get the XmlEnumAttribute
            object[] o = info.GetCustomAttributes(typeof(XmlEnumAttribute), false);
            XmlEnumAttribute att = (XmlEnumAttribute)o[0];
            return att.Name;
        }
    }

    public class DataItem
    {
        public DataItem(string columnName, string dataSheet, Type dataType, bool mandatory = false, int dataLength = -1, List<string> validValues = null)
        {
            ColumnName = columnName;
            DataSheet = dataSheet;
            DataType = dataType;
            DataLength = dataLength;
            Mandatory = mandatory;
            ValidValues = validValues;
        }

        public string DataSheet { get; set; }

        public Type DataType { get; set; }

        public int DataLength { get; set; }

        public string ColumnName { get; set; }

        public bool Mandatory { get; set; }

        public List<string> ValidValues { get; set; }

        public string OverrideErrorMessage { get; set; }
    }
}
