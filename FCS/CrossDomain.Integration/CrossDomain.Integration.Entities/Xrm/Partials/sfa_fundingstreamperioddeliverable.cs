namespace SFA.FCT.CrossDomain.Integration.Entities.Xrm
{
    public partial class sfa_fundingstreamperioddeliverable
    {
        [Microsoft.Xrm.Sdk.AttributeLogicalNameAttribute("sfa_paymentcappinggroup")]
        public Microsoft.Xrm.Sdk.OptionSetValue sfa_PaymentCappingGroup
        {
            [System.Diagnostics.DebuggerNonUserCode()]
            get
            {
                return this.GetAttributeValue<Microsoft.Xrm.Sdk.OptionSetValue>("sfa_paymentcappinggroup");
            }
            [System.Diagnostics.DebuggerNonUserCode()]
            set
            {
                this.OnPropertyChanging("sfa_PaymentCappingGroup");
                this.SetAttributeValue("sfa_paymentcappinggroup", value);
                this.OnPropertyChanged("sfa_PaymentCappingGroup");
            }
        }

        /// <summary>
		/// A sequence number within a Funding Stream used to identify a (Contract) Deliverable
		/// </summary>
		[Microsoft.Xrm.Sdk.AttributeLogicalNameAttribute("sfa_setting_displayorder")]
        [System.Diagnostics.DebuggerNonUserCode()]
        public System.Nullable<int> sfa_setting_displayorder
        {
            get
            {
                return this.GetAttributeValue<System.Nullable<int>>("sfa_setting_displayorder");
            }
            set
            {
                this.OnPropertyChanging("sfa_setting_displayorder");
                this.SetAttributeValue("sfa_setting_displayorder", value);
                this.OnPropertyChanged("sfa_setting_displayorder");
            }
        }
    }
}
