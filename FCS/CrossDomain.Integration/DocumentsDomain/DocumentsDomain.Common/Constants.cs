namespace SFA.FCT.DocumentsDomain.Common
{
    public class Constants
    {
        public static string DocumentsDomain => "DocumentsDomain";

        public static string TemplateMainTableName => "MainTable";

        public static string SubRowMarker => "^s";

        public static string IndentTextMarker => "^t";

        public static string BoldTextMarker => "^b";

        public static string ItalicTextMarker => "^i";

        public static string EndOfTextMarker => "¶";

        public static string MergeThisAndCellAboveMarker => "^m";

        public static string Position_Appendix2_HEADER => "2000";

        public static string TemplateForAppendix2_Header => "A2H_{0}";

        public static string DecimalToValueFormat => "F2";

        public static string DecimalToVolumeFormat => "{0}{1:#,0}{2}";

        public static string NotApplicable => "N/A";

        public static string RemovePoundSignMarker => "^p";

        public static string UnitCostFieldName = "UnitCost";

        public static string CashFieldName = "Cash";

        public static string TotalCashFieldName = "TCash";

        public static string CvFieldName = "CV";       

        public static string NameFielddName = "Name";

        public static string PaymentScheduleGroupId = "PaymentScheduleGroup";

        /* Doc Move */
        public static string PublishedToProviderOverrideDateKey => "PublishedToProviderDate";
        
        public static string MergedDocumentDoesNotExistErrorMessage => "There was a failure to publish documentation for UKPRN: {0} & Contract: {1}. This failure was caused by no valid documentation being present in the relevant Document Library. Please check the merged contract documentation is present and re-try";
    }
}
