namespace SFA.FCT.CrossDomain.Integration.Entities.Xrm
{
    /// <summary>
    /// The generated type is missing some properties
    /// </summary>
    public partial class sfa_fundingstreamperiod
    {
        [Microsoft.Xrm.Sdk.AttributeLogicalNameAttribute("sfa_paymenttype")]
        public Microsoft.Xrm.Sdk.OptionSetValue sfa_PaymentType
        {
            [System.Diagnostics.DebuggerNonUserCode()]
            get
            {
                return this.GetAttributeValue<Microsoft.Xrm.Sdk.OptionSetValue>("sfa_paymenttype");
            }
            [System.Diagnostics.DebuggerNonUserCode()]
            set
            {
                this.OnPropertyChanging("sfa_PaymentType");
                this.SetAttributeValue("sfa_paymenttype", value);
                this.OnPropertyChanged("sfa_PaymentType");
            }
        }

        [Microsoft.Xrm.Sdk.AttributeLogicalNameAttribute("sfa_paymentcappinglevel")]
        public Microsoft.Xrm.Sdk.OptionSetValue sfa_PaymentCappingLevel
        {
            [System.Diagnostics.DebuggerNonUserCode()]
            get
            {
                return this.GetAttributeValue<Microsoft.Xrm.Sdk.OptionSetValue>("sfa_paymentcappinglevel");
            }
            [System.Diagnostics.DebuggerNonUserCode()]
            set
            {
                this.OnPropertyChanging("sfa_PaymentCappingLevel");
                this.SetAttributeValue("sfa_paymentcappinglevel", value);
                this.OnPropertyChanged("sfa_PaymentCappingLevel");
            }
        }

    }
}
