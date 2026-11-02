namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class sfa_contract
    {
        public Guid Id { get; set; }

        public DateTime? SinkCreatedOn { get; set; }

        public DateTime? SinkModifiedOn { get; set; }

        public int? statecode { get; set; }

        public int? statuscode { get; set; }

        public int? sfa_hierarchytype { get; set; }

        public int? sfa_contractstatus { get; set; }

        public int? sfa_inflightnewstartssuspendedreason { get; set; }

        public int? sfa_serviceresponse { get; set; }

        public int? sfa_defaultnewstartssuspendedreason { get; set; }

        public int? sfa_terminationreason { get; set; }

        public int? sfa_inflightterminationreason { get; set; }

        public int? sfa_amendmenttype { get; set; }

        public bool? sfa_readyforupdates { get; set; }

        public bool? sfa_lastapprovedversion { get; set; }

        public bool? sfa_initiateamendment { get; set; }

        public bool? sfa_skipcaseloadassignment { get; set; }

        public bool? sfa_isnonfinancialamendment { get; set; }

        public bool? sfa_terminationvalidcheck { get; set; }

        public bool? sfa_skipreviewandinternalapproval { get; set; }

        public bool? sfa_documentationrequired { get; set; }

        public bool? sfa_skipdocumentmerge { get; set; }

        public bool? sfa_latestversion { get; set; }

        public bool? sfa_nfainprogress { get; set; }

        public Guid? owninguser { get; set; }

        [StringLength(128)]
        public string owninguser_entitytype { get; set; }

        public Guid? transactioncurrencyid { get; set; }

        [StringLength(128)]
        public string transactioncurrencyid_entitytype { get; set; }

        public Guid? sfa_contracttype { get; set; }

        [StringLength(128)]
        public string sfa_contracttype_entitytype { get; set; }

        public Guid? sfa_providername { get; set; }

        [StringLength(128)]
        public string sfa_providername_entitytype { get; set; }

        public Guid? sfa_fundingtype { get; set; }

        [StringLength(128)]
        public string sfa_fundingtype_entitytype { get; set; }

        public Guid? owningteam { get; set; }

        [StringLength(128)]
        public string owningteam_entitytype { get; set; }

        public Guid? sfa_taskownerforclosure { get; set; }

        [StringLength(128)]
        public string sfa_taskownerforclosure_entitytype { get; set; }

        public Guid? sfa_currenttask { get; set; }

        [StringLength(128)]
        public string sfa_currenttask_entitytype { get; set; }

        public Guid? sfa_contractadviser { get; set; }

        [StringLength(128)]
        public string sfa_contractadviser_entitytype { get; set; }

        public Guid? modifiedonbehalfby { get; set; }

        [StringLength(128)]
        public string modifiedonbehalfby_entitytype { get; set; }

        public Guid? sfa_approvalrequestedby { get; set; }

        [StringLength(128)]
        public string sfa_approvalrequestedby_entitytype { get; set; }

        public Guid? sfa_nextaction { get; set; }

        [StringLength(128)]
        public string sfa_nextaction_entitytype { get; set; }

        public Guid? sfa_taskownerpriorclosure { get; set; }

        [StringLength(128)]
        public string sfa_taskownerpriorclosure_entitytype { get; set; }

        public Guid? sfa_contractapprovedby { get; set; }

        [StringLength(128)]
        public string sfa_contractapprovedby_entitytype { get; set; }

        public Guid? sfa_previousversion { get; set; }

        [StringLength(128)]
        public string sfa_previousversion_entitytype { get; set; }

        public Guid? sfa_lastworkflowhistory { get; set; }

        [StringLength(128)]
        public string sfa_lastworkflowhistory_entitytype { get; set; }

        public Guid? modifiedby { get; set; }

        [StringLength(128)]
        public string modifiedby_entitytype { get; set; }

        public Guid? sfa_terminationselection { get; set; }

        [StringLength(128)]
        public string sfa_terminationselection_entitytype { get; set; }

        public Guid? createdby { get; set; }

        [StringLength(128)]
        public string createdby_entitytype { get; set; }

        public Guid? sfa_specialtaskowner { get; set; }

        [StringLength(128)]
        public string sfa_specialtaskowner_entitytype { get; set; }

        public Guid? sfa_parentcontractid { get; set; }

        [StringLength(128)]
        public string sfa_parentcontractid_entitytype { get; set; }

        public Guid? owningbusinessunit { get; set; }

        [StringLength(128)]
        public string owningbusinessunit_entitytype { get; set; }

        public Guid? sfa_periodid { get; set; }

        [StringLength(128)]
        public string sfa_periodid_entitytype { get; set; }

        public Guid? sfa_substatus { get; set; }

        [StringLength(128)]
        public string sfa_substatus_entitytype { get; set; }

        public Guid? createdonbehalfby { get; set; }

        [StringLength(128)]
        public string createdonbehalfby_entitytype { get; set; }

        public Guid? ownerid { get; set; }

        [StringLength(128)]
        public string ownerid_entitytype { get; set; }

        public decimal? sfa_contractvalue { get; set; }

        public decimal? sfa_contractvalue_base { get; set; }

        [StringLength(200)]
        public string sfa_specialtaskowneryominame { get; set; }

        public int? importsequencenumber { get; set; }

        [StringLength(200)]
        public string sfa_currenttaskname { get; set; }

        public int? sfa_subversion { get; set; }

        [StringLength(100)]
        public string sfa_correlation { get; set; }

        [StringLength(20)]
        public string sfa_parentcontractidname { get; set; }

        [StringLength(160)]
        public string sfa_providernameyominame { get; set; }

        [StringLength(160)]
        public string sfa_providernamename { get; set; }

        [StringLength(200)]
        public string sfa_taskownerforclosureyominame { get; set; }

        [StringLength(100)]
        public string sfa_lastworkflowhistoryname { get; set; }

        public DateTime? sfa_inflightstopnewstartsdate { get; set; }

        [StringLength(100)]
        public string createdbyname { get; set; }

        [StringLength(200)]
        public string sfa_specialtaskownername { get; set; }

        [StringLength(100)]
        public string owneridname { get; set; }

        public int? sfa_upin { get; set; }

        public DateTime? sfa_datewithdrawn { get; set; }

        public DateTime? sfa_contractpublisheddate { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyname { get; set; }

        public DateTime? sfa_datepublished { get; set; }

        [StringLength(100)]
        public string sfa_periodidname { get; set; }

        [StringLength(200)]
        public string sfa_contractapprovedbyyominame { get; set; }

        [StringLength(200)]
        public string sfa_contractadvisername { get; set; }

        public DateTime? sfa_startdate { get; set; }

        [StringLength(100)]
        public string modifiedbyname { get; set; }

        public decimal? exchangerate { get; set; }

        [StringLength(100)]
        public string sfa_fundingtypename { get; set; }

        [StringLength(100)]
        public string sfa_inflightinitiateamendment { get; set; }

        public long? versionnumber { get; set; }

        [StringLength(200)]
        public string sfa_approvalrequestedbyname { get; set; }

        public DateTime? sfa_terminationdate { get; set; }

        [StringLength(100)]
        public string sfa_terminationinprogress { get; set; }

        public DateTime? sfa_statuslastupdateddate { get; set; }

        [StringLength(50)]
        public string sfa_ukprn { get; set; }

        [StringLength(100)]
        public string sfa_intent { get; set; }

        public string sfa_reasonforrejection { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyname { get; set; }

        public DateTime? sfa_contractapprovaldate { get; set; }

        [StringLength(20)]
        public string sfa_number { get; set; }

        [StringLength(100)]
        public string transactioncurrencyidname { get; set; }

        public DateTime? createdon { get; set; }

        public DateTime? overriddencreatedon { get; set; }

        public DateTime? sfa_inflightterminationdate { get; set; }

        public Guid? sfa_contractid { get; set; }

        [StringLength(20)]
        public string sfa_previousversionname { get; set; }

        [StringLength(200)]
        public string sfa_taskownerpriorclosureyominame { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyyominame { get; set; }

        [StringLength(200)]
        public string sfa_approvalrequestedbyyominame { get; set; }

        public int? utcconversiontimezonecode { get; set; }

        public int? sfa_version { get; set; }

        [StringLength(200)]
        public string sfa_taskownerforclosurename { get; set; }

        public string sfa_inflightterminationcomments { get; set; }

        [StringLength(100)]
        public string sfa_substatusname { get; set; }

        [StringLength(100)]
        public string owneridyominame { get; set; }

        [StringLength(100)]
        public string createdbyyominame { get; set; }

        [StringLength(100)]
        public string sfa_terminationselectionname { get; set; }

        public DateTime? modifiedon { get; set; }

        public DateTime? sfa_defaultstopnewstartsdate { get; set; }

        public decimal? sfa_variation { get; set; }

        public string sfa_terminationcomments { get; set; }

        [StringLength(100)]
        public string modifiedbyyominame { get; set; }

        [StringLength(100)]
        public string sfa_contracttypename { get; set; }

        [StringLength(100)]
        public string sfa_contractidentifier { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyyominame { get; set; }

        [StringLength(200)]
        public string sfa_taskownerpriorclosurename { get; set; }

        [StringLength(100)]
        public string sfa_description { get; set; }

        [StringLength(200)]
        public string sfa_contractadviseryominame { get; set; }

        [StringLength(4000)]
        public string owneridtype { get; set; }

        [StringLength(200)]
        public string sfa_contractapprovedbyname { get; set; }

        public DateTime? sfa_enddate { get; set; }

        [StringLength(100)]
        public string sfa_documentation { get; set; }

        [StringLength(100)]
        public string sfa_nextactionname { get; set; }

        public int? timezoneruleversionnumber { get; set; }

        [StringLength(160)]
        public string owningbusinessunitname { get; set; }
    }
}
