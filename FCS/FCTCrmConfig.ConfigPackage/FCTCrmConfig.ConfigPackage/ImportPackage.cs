namespace FCTCrmConfig.ConfigPackage
{
    using System;
    using System.ComponentModel.Composition;
    using System.IO;
    using System.Xml.Linq;

    // Rx Namspaces
    using System.Reactive.Linq;
    using System.Reactive.Subjects;
    using System.Reflection;

    // CRM Namespaces
    using Microsoft.Uii.Common.Entities;
    using Microsoft.Xrm.Tooling.PackageDeployment.CrmPackageExtentionBase;

    // Ciber Namespace for Configuration Importer
    using Ciber.Xrm.Packages;
    using Microsoft.Xrm.Sdk.Query;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Crm.Sdk.Messages;
    using System.Linq;
    /// <summary>
    /// Import package starter frame. 
    /// </summary>
    [Export(typeof(IImportExtensions))]
    public sealed class ImportPackage : ImportExtension, IDisposable
    {
        private readonly string _baseDirectoryName = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

        private Subject<DeploymentEvent> _eventStream;
        private XrmImportSystemData _importData;
        private LoadXrmContractNumbers _loadContractNumbers;
        private const string SOLUTIONNAME = "CIBERSFAFCTSolution";

        #region Properties

        /// <summary>
        /// Description of the package, used in the package selection UI
        /// </summary>
        public override string GetImportPackageDescriptionText
        {
            get { return "Package Description"; }
        }

        /// <summary>
        /// Long name of the Import Package. 
        /// </summary>
        public override string GetLongNameOfImport
        {
            get { return "Package Long Name"; }
        }

        /// <summary>
        /// Folder Name for the Package data. 
        /// </summary>
        public override string GetImportPackageDataFolderName
        {
            get
            {
                // WARNING this value directly correlates to the folder name in the Solution Explorer where the ImportConfig.xml and sub content is located. 
                // Changing this name requires that you also change the correlating name in the Solution Explorer 
                return "PkgFolder";
            }
        }

        /// <summary>
        /// Name of the Import Package to Use
        /// </summary>
        /// <param name="plural">if true, return plural version</param>
        /// <returns>string</returns>
        public override string GetNameOfImport(bool plural)
        {
            return "Package Short Name";
        }
        
        #endregion

        /// <summary>
        /// Called When the package is initialized. 
        /// </summary>
        public override void InitializeCustomExtension()
        {
            _eventStream = new Subject<DeploymentEvent>();

            _eventStream
                .Where(e => e.State == DeploymentEvent.OperationState.Started)
                .Subscribe(e => CreateProgressItem("Import Started: " + e.Message));

            _eventStream
                .Where(e => e.State == DeploymentEvent.OperationState.Completed)
                .Subscribe(
                    e =>
                    {
                        RaiseUpdateEvent(e.Message, ProgressPanelItemStatus.Complete);
                        PackageLog.Log(e.Message);
                    },
                    () =>
                    {
                        RaiseUpdateEvent("Complete", ProgressPanelItemStatus.Complete);
                        PackageLog.Log("Complete");
                    });

            _eventStream
                .Where(e => e.State == DeploymentEvent.OperationState.InProgress)
                .Subscribe(
                    e =>
                    {
                        CreateProgressItem(e.Message);
                        PackageLog.Log(e.Message);
                    },
                    ex =>
                    {
                        RaiseFailEvent(ex.Message, ex);
                        PackageLog.Log(ex.Message);
                    });
        }

        /// <summary>
        /// Called Before Import Completes. 
        /// </summary>
        /// <returns>bool</returns>
        public override bool BeforeImportStage()
        {
            try
            {
                string configDataFile = Path.Combine(_baseDirectoryName, GetImportPackageFolderName, @"Data\ConfigData\SystemConfigData.xml");

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message = "Importing Dynamics CRM Configuation data from: " + configDataFile,
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.ConfigFileLoad,
                    Level = DeploymentEvent.LogLevel.Info
                });


                if (CrmSvc == null)
                    throw new Exception("CRM Service is null");


                _importData = new XrmImportSystemData(CrmSvc, _eventStream);

                XDocument datafile = XDocument.Load(configDataFile);

                _importData.ConfigData = datafile;


                switch(_importData.GetDeploymentMode())
                {

                    case DeploymentMode.FullDeployment:

                        #region "Full Deployment Elements"

                        //_importData.UpdateSettings();

                        _importData.UpdateUsers();

                        _importData.ImportTeams();

                        _importData.ImportServices();


                        #endregion

                        break;

                    case DeploymentMode.RestoreDeployment:

                        _importData.UpdateUsers();

                        _importData.UpdateTeamMembers();

                        _importData.ImportServices();                        

                        break;

                    case DeploymentMode.ServicesDeployment:

                        _importData.ImportServices();

                        break;

                    default:
                        break;
                }

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message = "Dynamics CRM Configuration Data Load Complete",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.ConfigFileLoad,
                    Level = DeploymentEvent.LogLevel.Info
                });

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message = "Activating Dynamics CRM Workflows",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message = "Activating Dynamics CRM Workflows",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                _importData.ActivateWorkflow(SOLUTIONNAME);



            }
            catch (Exception ex)
            {
                _eventStream.OnError(ex);
            }

            return true;
        }

        /// <summary>
        /// Called for each UII record imported into the system
        /// This is UII Specific and is not generally used by Package Developers
        /// </summary>
        /// <param name="app">App Record</param>
        /// <returns>ApplicationRecord</returns>
        public override ApplicationRecord BeforeApplicationRecordImport(ApplicationRecord app)
        {
            return app;  // do nothing here. 
        }

        /// <summary>
        /// Called during a solution upgrade while both solutions are present in the target CRM instance. 
        /// This function can be used to provide a means to do data transformation or upgrade while a solution update is occurring. 
        /// </summary>
        /// <param name="solutionName">Name of the solution</param>
        /// <param name="oldVersion">version number of the old solution</param>
        /// <param name="newVersion">Version number of the new solution</param>
        /// <param name="oldSolutionId">Solution ID of the old solution</param>
        /// <param name="newSolutionId">Solution ID of the new solution</param>
        public override void RunSolutionUpgradeMigrationStep(string solutionName, string oldVersion, string newVersion, Guid oldSolutionId, Guid newSolutionId)
        {
            base.RunSolutionUpgradeMigrationStep(solutionName, oldVersion, newVersion, oldSolutionId, newSolutionId);
        }

        /// <summary>
        /// Called after Import completes. 
        /// </summary>
        /// <returns>bool</returns>
        public override bool AfterPrimaryImport()
        {
            // Read configuration data file from PkgFolder
            string configDataFile = Path.Combine(_baseDirectoryName, GetImportPackageFolderName, @"Data\PostImportUpdate.xml");
            string contractNumbersFile = Path.Combine(_baseDirectoryName, GetImportPackageFolderName, @"Data\ConfigData\ContractNumbers.xml");

            try
            {
                //_loadContractNumbers = new LoadXrmContractNumbers(contractNumbersFile, CrmSvc, _eventStream);

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message = "Importing Dynamics CRM Configuation data from: " + configDataFile,
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.ConfigFileLoad,
                    Level = DeploymentEvent.LogLevel.Info
                });

                _importData.ConfigData = XDocument.Load(configDataFile);

                _importData.UpdateTransitions();

                _importData.UpdateTaskActions();

                _importData.UpdateTerminationSelections();

                //this is optional for each release, if any record needs to be removed from target environement, add them in PostImportUpdate.xml RedundantEntities Section 
                //in following XML format
                //    < RedundantRecord >
                //< EntityType >entity schema name e.g. sfa_transition </ EntityType >
                //< RecordName > unique name for name field/sfa_name field e.g. Reject Published Contract</ RecordName >
                //         </ RedundantRecord >

                // _importData.RemoveRedundantRecords();


                //  _loadContractNumbers.LoadContractNumbers();

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message = "Dynamics CRM Configuration Data Load Complete",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.ConfigFileLoad,
                    Level = DeploymentEvent.LogLevel.Info
                });

                _eventStream.OnCompleted();
            }
            catch (Exception ex)
            {
                _eventStream.OnError(ex);
            }
            finally
            {
                _eventStream.Dispose();
            }

            return true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private void Dispose(bool disposing)
        {
            if (!disposing)
            {
                return;
            }

            if (_eventStream != null)
            {
                _eventStream.Dispose();
            }
        }
    }
}
