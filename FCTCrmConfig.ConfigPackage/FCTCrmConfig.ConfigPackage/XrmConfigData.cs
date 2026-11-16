// <copyright file="XrmConfigData.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace Ciber.Xrm.Packages
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Linq;
    using FCTCrmConfig.ConfigPackage;

    // Dynamics CRM Namespaces
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;

    // Dynamics CRM Packaging Namespaces
    using Microsoft.Xrm.Tooling.Connector;
    using System.ServiceModel;


    /// <summary>
    /// XrmImportSystemData Class - used to import System Data (Users, Teams, Business Units, User Roles, Team Roles, Queues
    /// </summary>
    public class XrmImportSystemData
    {
        #region Fields

        /// <summary>
        /// Gets value for the Organization Service
        /// </summary>
        private readonly CrmServiceClient _crmServiceClient;

        private readonly IObserver<DeploymentEvent> _eventStream;

        private readonly Dictionary<string, int> _utcTimeZoneSettings = new Dictionary<string, int>
        {
            { "timezonebias", 0 },
            { "timezonestandardbias", 0 },
            { "timezonedaylightbias", 0 },
            { "timezonecode", 92 },
            { "timezonestandardyear", 0 },
            { "timezonestandardmonth", 0 },
            { "timezonestandardday", 0 },
            { "timezonestandarddayofweek", 0 },
            { "timezonestandardhour", 0 },
            { "timezonestandardminute", 0 },
            { "timezonestandardsecond", 0 },
            { "timezonedaylightyear", 0 },
            { "timezonedaylightmonth", 0 },
            { "timezonedaylightday", 0 },
            { "timezonedaylightdayofweek", 0 },
            { "timezonedaylighthour", 0 },
            { "timezonedaylightminute", 0 },
            { "timezonedaylightsecond", 0 }
        };

        #endregion

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="XrmImportSystemData"/> class
        /// </summary>
        /// <param name="serviceClient">The CrmServiceClient object passed through from the Package Deployment context</param>
        /// <param name="eventStream">The Rx eventStream to push notifications onto</param>
        public XrmImportSystemData(CrmServiceClient serviceClient, IObserver<DeploymentEvent> eventStream)
        {
            _crmServiceClient = serviceClient;
            _eventStream = eventStream;
        }

        #endregion

        #region Properties

        public XDocument ConfigData { get; set; }

        #endregion

        #region Methods

        public void UpdateSettings()
        {
            if (ConfigData.Root != null && ConfigData.Root.Elements("Settings").Any())
            {
                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message = "Updating Settings",
                    Type = DeploymentEvent.OperationType.SettingsUpdate,
                    State = DeploymentEvent.OperationState.Started
                });

                UpdateSystemSettings(ConfigData.Root.Element("Settings"));

                // This has been removed as the import user needs to use the US Format
                UpdateUserDataFormat();

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message = "Updating Settings Completed",
                    Type = DeploymentEvent.OperationType.SettingsUpdate,
                    State = DeploymentEvent.OperationState.Completed
                });
            }
        }

        /// <summary>
        /// Imports the business units specified in the XElement provided
        /// </summary>
        public void ImportBusinessUnits()
        {
            if (ConfigData.Root != null)
            {
                XElement businessUnitData = ConfigData.Root.Element("BusinessUnits");

                if (businessUnitData != null)
                {
                    _eventStream.OnNext(new DeploymentEvent()
                    {
                        Message = "Importing Business Units (" + businessUnitData
                            .Elements("BusinessUnit")
                            .Count() + ")",
                        State = DeploymentEvent.OperationState.Started,
                        Type = DeploymentEvent.OperationType.RecordCreate,
                        Level = DeploymentEvent.LogLevel.Info
                    });

                    var businessUnits = from item in businessUnitData.Descendants("BusinessUnit")
                                        select new
                                        {
                                            BusinessUnitName = item.Attribute("name").Value,
                                            ParentBusinessUnit = item.Element("ParentBusinessUnit").Value
                                        };

                    foreach (var bu in businessUnits)
                    {
                        try
                        {
                            Guid businessUnitId = CreateBusinessUnit(bu.ParentBusinessUnit, bu.BusinessUnitName);
                            _eventStream.OnNext(new DeploymentEvent()
                            {
                                Message =
                                    "Imported Business Unit: " + bu.BusinessUnitName + " with Id: " + businessUnitId,
                                State = DeploymentEvent.OperationState.InProgress,
                                Type = DeploymentEvent.OperationType.RecordCreate,
                                Level = DeploymentEvent.LogLevel.Verbose
                            });
                        }
                        catch (Exception ex)
                        {
                            _eventStream.OnNext(new DeploymentEvent()
                            {
                                Message =
                                    "Failed to import Business Unit: " + bu.BusinessUnitName + " Error: " + ex.Message,
                                State = DeploymentEvent.OperationState.InProgress,
                                Type = DeploymentEvent.OperationType.RecordCreate,
                                Level = DeploymentEvent.LogLevel.Warning
                            });
                        }
                    }
                }
            }

            _eventStream.OnNext(new DeploymentEvent()
            {
                Message = "Importing Business Units Complete",
                State = DeploymentEvent.OperationState.Completed,
                Type = DeploymentEvent.OperationType.RecordCreate,
                Level = DeploymentEvent.LogLevel.Info
            });
        }

        public void ImportUsers()
        {
            if (ConfigData.Root != null)
            {
                XElement systemUserData = ConfigData.Root.Element("SystemUsers");

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Importing System Users (" +
                        systemUserData.Elements("SystemUser").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordCreate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                var systemUsers = from item in systemUserData.Descendants("SystemUser")
                                  select new
                                  {
                                      DomainName = item.Attribute("domainname").Value,
                                      FirstName = item.Element("FirstName").Value,
                                      LastName = item.Element("LastName").Value,
                                      BusinessUnit = item.Element("BusinessUnit").Value,
                                      Email = item.Element("Email").Value,
                                      Telephone = item.Element("Telephone").Value,
                                      Manager = item.Element("Manager").Value,
                                      Title = item.Element("Title").Value,
                                      AccessMode = int.Parse(item.Element("AccessMode").Value),
                                      LicenseType = int.Parse(item.Element("LicenseType").Value),
                                      Roles = item.Element("Roles")
                                  };

                foreach (var su in systemUsers)
                {
                    try
                    {
                        var entSystemUser = new Entity("systemuser");
                        entSystemUser.Attributes["domainname"] = su.DomainName;
                        entSystemUser.Attributes["firstname"] = su.FirstName;
                        entSystemUser.Attributes["lastname"] = su.LastName;
                        entSystemUser.Attributes["businessunitid"] = new EntityReference("businessunit", GetBusinessUnitId(su.BusinessUnit));
                        entSystemUser.Attributes["internalemailaddress"] = su.Email;
                        entSystemUser.Attributes["address1_telephone1"] = su.Telephone;
                        entSystemUser.Attributes["title"] = su.Title;
                        entSystemUser.Attributes["accessmode"] = new OptionSetValue(su.AccessMode);
                        entSystemUser.Attributes["caltype"] = new OptionSetValue(su.LicenseType);
                        if (!string.IsNullOrEmpty(su.Manager))
                        {
                            entSystemUser.Attributes["sfa_manager"] = new EntityReference("systemuser", GetSystemUserId(su.Manager));
                        }

                        Guid sysUserGuid = CreateSystemUser(entSystemUser, su.BusinessUnit, su.Roles);
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message = "Imported User: " + su.DomainName + " with Id: " + sysUserGuid,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordCreate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Failed to import User: " + su.DomainName + " Error: " + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordCreate,
                            Level = DeploymentEvent.LogLevel.Warning
                        });
                    }
                }

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Importing System Users Complete",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.RecordCreate,
                    Level = DeploymentEvent.LogLevel.Info
                });
            }
        }

        public void UpdateUsers()
        {
            if (ConfigData.Root != null)
            {
                XElement systemUserData = ConfigData.Root.Element("SystemUsers");

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Updating System Users (" +
                        systemUserData.Elements("SystemUser").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                var systemUsers = from item in systemUserData.Descendants("SystemUser")
                                  select new
                                  {
                                      DomainName = item.Attribute("domainname").Value,
                                      PrimaryRole = item.Element("PrimaryRole").Value,
                                      BusinessUnit = item.Element("BusinessUnit").Value,
                                      Manager = item.Element("Manager").Value,
                                      Roles = item.Element("Roles")
                                  };

                foreach (var su in systemUsers.Where(s => s.PrimaryRole != string.Empty))
                {
                    try
                    {
                        System.Diagnostics.Debug.Print(su.PrimaryRole);
                        Entity entSystemUser = new Entity("systemuser")
                        {
                            Id = GetSystemUserId(su.DomainName)
                        };

                        if (!string.IsNullOrEmpty(su.PrimaryRole))
                        {
                            entSystemUser.Attributes["sfa_primaryrole"] = new EntityReference("team", GetTeamId(su.PrimaryRole));
                        }

                        if (!string.IsNullOrEmpty(su.Manager))
                        {
                            entSystemUser.Attributes["sfa_manager"] = new EntityReference("systemuser", GetRecordId(su.Manager, "domainname", "systemuser", "systemuserid"));
                        }

                        UpdateSystemUser(entSystemUser);

                        // Import Roles for User - Pass System User and BU Guid and Roles collection
                        CreateRolesForUser(entSystemUser.Id, su.DomainName.ToString(), su.BusinessUnit, su.Roles);

                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Updated User: " + su.DomainName,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordUpdate,
                            Level = DeploymentEvent.LogLevel.Verbose

                        });
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Failed to update User: " + su.DomainName + " with Primary Role: " + su.PrimaryRole + ". Error: " + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordUpdate,
                            Level = DeploymentEvent.LogLevel.Warning
                        });
                    }
                }

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Update System Users Complete",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });
            }
        }

        public void UpdateStatuses(XElement statusesData)
        {
            var statuses = from item in statusesData.Descendants("Status")
                           select new
                           {
                               Name = item.Element("Name").Value,
                               DefaultBulkAction = item.Element("DefaultBulkAction").Value
                           };

            foreach (var s in statuses)
            {
                List<CrmServiceClient.CrmSearchFilter> searchParameters = new List<CrmServiceClient.CrmSearchFilter>();

                var searchConditions = new List<CrmServiceClient.CrmFilterConditionItem>();
                searchConditions.Add(new CrmServiceClient.CrmFilterConditionItem()
                {
                    FieldName = "sfa_name",
                    FieldOperator = ConditionOperator.Equal,
                    FieldValue = s.Name
                });

                searchParameters.Add(new CrmServiceClient.CrmSearchFilter()
                {
                    FilterOperator = LogicalOperator.And,
                    SearchConditions = searchConditions
                });

                var data = _crmServiceClient.GetEntityDataBySearchParams(
                    "sfa_status",
                    searchParameters,
                    CrmServiceClient.LogicalSearchOperator.And,
                    new List<string>() { "sfa_name", "sfa_statusid" });

                foreach (var pair in data)
                {
                    Console.WriteLine("Key {0} Value {1}", pair.Key, pair.Value);
                }

                var oid = data.FirstOrDefault(x => x.Key.Equals("sfa_statusid")).Value;

                Guid id = Guid.Parse(oid.ToString());

                var updateData = new Dictionary<string, CrmDataTypeWrapper>();

                updateData.Add("sfa_defaultbulkaction", new CrmDataTypeWrapper(s.DefaultBulkAction, CrmFieldType.String));

                _crmServiceClient.UpdateEntity("sfa_status", "sfa_statusid", id, updateData);
            }
        }

        /// <summary>
        /// Import the teams specified in the XElement data
        /// </summary>
        public void ImportTeams()
        {
            if (ConfigData.Root != null)
            {
                XElement teamData = ConfigData.Root.Element("Teams");

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Importing Teams (" +
                        teamData.Elements("Team").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordCreate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                var teams = from item in teamData.Descendants("Team")
                            select new
                            {
                                TeamName = item.Attribute("name").Value,
                                BusinessUnit = item.Element("BusinessUnit").Value,
                                Manager = item.Element("Manager").Value,
                                Description = item.Element("Description").Value,
                                Members = item.Element("Members"),
                                Roles = item.Element("Roles")
                            };

                foreach (var t in teams)
                {
                    try
                    {
                        Guid newTeamGuid = CreateTeam(t.BusinessUnit, t.TeamName, t.Manager, t.Members, t.Roles);

                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Imported Team: " + t.TeamName + " with Id: " + newTeamGuid,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordCreate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Failed to import Team: " + t.TeamName + " Error: " + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordCreate,
                            Level = DeploymentEvent.LogLevel.Warning
                        });
                    }
                }

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Importing Teams Complete",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.RecordCreate,
                    Level = DeploymentEvent.LogLevel.Info
                });
            }
        }

        /// <summary>
        /// Update the team members specified in the XElement data
        /// </summary>
        public void UpdateTeamMembers()
        {
            if (ConfigData.Root != null)
            {
                XElement teamData = ConfigData.Root.Element("Teams");

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Update Team Members (" +
                        teamData.Elements("Team").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordCreate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                var teams = from item in teamData.Descendants("Team")
                            select new
                            {
                                TeamName = item.Attribute("name").Value,
                                BusinessUnit = item.Element("BusinessUnit").Value,
                                Manager = item.Element("Manager").Value,
                                Description = item.Element("Description").Value,
                                Members = item.Element("Members"),
                                Roles = item.Element("Roles")
                            };

                foreach (var t in teams)
                {
                    try
                    {
                        Guid newTeamGuid = CreateTeam(t.BusinessUnit, t.TeamName, t.Manager, t.Members, t.Roles);
                        Guid teamId = GetRecordId(t.TeamName, "name", "team", "teamid");
                        if (teamId != Guid.Empty)
                        {
                            CreateTeamMembers(teamId, t.Roles);

                            _eventStream.OnNext(new DeploymentEvent()
                            {
                                Message =
                                    "Updated Team Members for: " + t.TeamName + " with Id: " + newTeamGuid,
                                State = DeploymentEvent.OperationState.InProgress,
                                Type = DeploymentEvent.OperationType.RecordCreate,
                                Level = DeploymentEvent.LogLevel.Verbose
                            });

                        }
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Failed to Updated Team Members for: " + t.TeamName + " Error: " + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordCreate,
                            Level = DeploymentEvent.LogLevel.Warning
                        });
                    }
                }

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Updating Team Members Complete",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.RecordCreate,
                    Level = DeploymentEvent.LogLevel.Info
                });
            }
        }


        /// <summary>
        /// Update the transition owners as specified in the configuration data
        /// </summary>
        public void UpdateTransitions()
        {
            if (ConfigData.Root != null)
            {
                XElement transitionsData = ConfigData.Root.Element("Transitions");

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Updating Transitions (" +
                        transitionsData.Elements("TransitionRecord").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                var transitions =
                    from item in transitionsData.Descendants("TransitionRecord")
                    select new
                    {
                        Name = item.Element("Name").Value,
                        ManagersTeam = item.Element("ManagersTeam").Value,
                        Owner = item.Element("Owner").Value,
                    };

                foreach (var t in transitions)
                {
                    try
                    {
                        UpdateTransition(t.Name, t.ManagersTeam, t.Owner);
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Updated Transition: " + t.Name,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordUpdate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Failed to update Transition: " + t.Name + " Error:" + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordUpdate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                }

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Updating Transitions Complete",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });
            }
        }



        /// <summary>
        /// Update the TaskAction Team as specified in the configuration data
        /// </summary>
        public void UpdateTaskActions()
        {
            if (ConfigData.Root != null)
            {
                XElement taskActionsData = ConfigData.Root.Element("TaskActions");

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Updating TaskActions (" +
                        taskActionsData.Elements("TaskAction").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                var taskactionlist =
                    from item in taskActionsData.Descendants("TaskAction")
                    select new
                    {
                        TaskName = item.Element("TaskName").Value,
                        ActionTeam = item.Element("TaskActionTeam").Value

                    };

                foreach (var t in taskactionlist)
                {
                    try
                    {
                        UpdateTaskAction(t.TaskName, t.ActionTeam);
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Updated TaskAction: " + t.TaskName + "with Action Team : " + t.ActionTeam,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordUpdate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Failed to update TaskAction: " + t.TaskName + " Error:" + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordUpdate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                }

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Updating TaskActions Complete",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });
            }
        }


        /// <summary>
        /// Update the Termination Selection Team as specified in the configuration data
        /// </summary>
        public void UpdateTerminationSelections()
        {
            if (ConfigData.Root != null)
            {
                XElement termSelectionsData = ConfigData.Root.Element("TerminationSelections");

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Updating TerminationSelections (" +
                        termSelectionsData.Elements("TerminationSelection").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                var termSelectionslist =
                    from item in termSelectionsData.Descendants("TerminationSelection")
                    select new
                    {
                        SelectionName = item.Element("SelectionName").Value,
                        SelectionTeam = item.Element("SelectionTeam").Value

                    };

                foreach (var t in termSelectionslist)
                {
                    try
                    {
                        UpdateTerminationSelection(t.SelectionName, t.SelectionTeam);
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Updated TerminationSelection: " + t.SelectionName + "with Action Team : " + t.SelectionTeam,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordUpdate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Failed to update TerminationSelection: " + t.SelectionName + " Error:" + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordUpdate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                }

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Updating TerminationSelections Complete",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });
            }
        }



        /// <summary>
        /// Remove unused record in the system as CRM Configuration Migration cannot delete or remove unnecessary data
        /// </summary>
        public void RemoveRedundantRecords()
        {

            if (ConfigData.Root != null)
            {
                XElement transitionsData = ConfigData.Root.Element("RedundantEntities");

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Remove Redundant Record (" +
                        transitionsData.Elements("RedundantRecord").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                var redundantrecords =
                    from item in transitionsData.Descendants("RedundantRecord")
                    select new
                    {
                        Type = item.Element("EntityType").Value,
                        Name = item.Element("RecordName").Value,

                    };

                foreach (var t in redundantrecords)
                {
                    try
                    {
                        RemoveRedundantRecord(t.Type, t.Name);
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Removed Redundant Record: EntityType - " + t.Type + " Name - " + t.Name,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordUpdate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message =
                                "Failed to remove redundant record: " + t.Name + " Error:" + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordUpdate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                }

                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Removing Reduant Records Complete",
                    State = DeploymentEvent.OperationState.Completed,
                    Type = DeploymentEvent.OperationType.RecordUpdate,
                    Level = DeploymentEvent.LogLevel.Info
                });
            }

        }


        /// <summary>
        /// Import the Queues specified in the XElement Data
        /// </summary>
        public void ImportQueues()
        {
            XElement queueData = ConfigData.Element("Queues");

            if (queueData != null)
            {
                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Importing Queues (" +
                        queueData.Elements("Queue").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordCreate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                var queues = from item in queueData.Descendants("Queue")
                             select new
                             {
                                 QueueName = item.Attribute("name").Value,
                                 ViewType = item.Element("ViewType").Value,
                                 Description = item.Element("Description").Value,
                                 Email = item.Element("Email").Value,
                                 FileringMethod = item.Element("FilteringMethod").Value
                             };

                foreach (var q in queues)
                {
                    Entity entQueue = new Entity("queue");
                    entQueue.Attributes["name"] = q.QueueName;
                    entQueue.Attributes["queueviewtype"] = new OptionSetValue(int.Parse(q.ViewType));
                    entQueue.Attributes["description"] = q.Description;
                    entQueue.Attributes["emailaddress"] = q.Email;
                    entQueue.Attributes["incomingemailfilteringmethod"] = new OptionSetValue(int.Parse(q.FileringMethod));

                    try
                    {
                        Guid newQueueGuid = CreateQueue(entQueue);
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message = "Imported Queue: " + q.QueueName + " with Id: " + newQueueGuid,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordCreate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message = "Failed to import queue: " + q.QueueName + " Error: " + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordCreate,
                            Level = DeploymentEvent.LogLevel.Warning
                        });
                    }
                }
            }

            _eventStream.OnNext(new DeploymentEvent()
            {
                Message = "Importing Queues Complete",
                State = DeploymentEvent.OperationState.Completed,
                Type = DeploymentEvent.OperationType.RecordCreate,
                Level = DeploymentEvent.LogLevel.Info
            });
        }

        /// <summary>
        /// Import Services in the XElement Data, this is an upsert method.
        /// </summary>
        public void ImportServices()
        {
            XElement servicesData = ConfigData.Root.Element("Services");

            if (servicesData != null)
            {
                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Importing Service (" +
                        servicesData.Elements("Service").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordCreate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                var services = from item in servicesData.Descendants("Service")
                               select new
                               {
                                   Name = item.Attribute("name").Value,
                                   URI = item.Element("URI").Value,
                                   AzureADInstance = item.Element("AzureADInstance").Value,
                                   AzureClientId = item.Element("AzureClientId").Value,
                                   AzureResourceID = item.Element("AzureResourceID").Value,
                                   AzureAppKey = item.Element("AzureAppKey").Value,
                                   AzureTenant = item.Element("AzureTenant").Value


                               };

                foreach (var service in services)
                {
                    Entity entWebresourceEntity = new Entity("sfa_webserviceresource");
                    entWebresourceEntity.Attributes["sfa_name"] = service.Name;
                    entWebresourceEntity.Attributes["sfa_uri"] = service.URI;
                    entWebresourceEntity.Attributes["sfa_azureadinstance"] = service.AzureADInstance;
                    entWebresourceEntity.Attributes["sfa_azureclientid"] = service.AzureClientId;
                    entWebresourceEntity.Attributes["sfa_azureresourceid"] = service.AzureResourceID;
                    entWebresourceEntity.Attributes["sfa_azureappkey"] = service.AzureAppKey;
                    entWebresourceEntity.Attributes["sfa_azuretenant"] = service.AzureTenant;


                    try
                    {
                        Guid webserviceResourceId = GetWebServiceResourceId(service.Name);
                        if (webserviceResourceId != Guid.Empty)
                        {
                            UpdateWebServiceResource(entWebresourceEntity);
                            _eventStream.OnNext(new DeploymentEvent()
                            {
                                Message = "Web Service Resoruce: " + service.Name + " Found, Skip Creation processes",
                                State = DeploymentEvent.OperationState.InProgress,
                                Type = DeploymentEvent.OperationType.RecordUpdate,
                                Level = DeploymentEvent.LogLevel.Verbose
                            });

                        }
                        else
                        {
                            Guid newServiceGuid = CreateWebResourceService(entWebresourceEntity);
                            _eventStream.OnNext(new DeploymentEvent()
                            {
                                Message = "Imported Service: " + service.Name + " with Id: " + newServiceGuid,
                                State = DeploymentEvent.OperationState.InProgress,
                                Type = DeploymentEvent.OperationType.RecordCreate,
                                Level = DeploymentEvent.LogLevel.Verbose
                            });
                        }
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message = "Failed to import Service: " + service.Name + " Error: " + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordCreate,
                            Level = DeploymentEvent.LogLevel.Warning
                        });
                    }
                }
            }

            _eventStream.OnNext(new DeploymentEvent()
            {
                Message = "Importing Services Complete",
                State = DeploymentEvent.OperationState.Completed,
                Type = DeploymentEvent.OperationType.RecordCreate,
                Level = DeploymentEvent.LogLevel.Info
            });
        }

        /// <summary>
        /// Delete all older Audit partitions other than current. This is to avoid large log space usage in test environments
        /// </summary>
        public void DeleteCRMAuditLogs()
        {

            _eventStream.OnNext(new DeploymentEvent()
            {
                Message = "Checking for older Audit Logs to delete",
                State = DeploymentEvent.OperationState.Started,
                Type = DeploymentEvent.OperationType.RecordUpdate,
                Level = DeploymentEvent.LogLevel.Info
            });

            // Get the list of audit partitions.
            var partitionRequest = (RetrieveAuditPartitionListResponse)_crmServiceClient.Execute(new RetrieveAuditPartitionListRequest());
            AuditPartitionDetailCollection partitions = partitionRequest.AuditPartitionDetailCollection;

            //increase timeout value as this is a time consuming operation
            //_crmServiceClient.OrganizationWebProxyClient.InnerChannel.OperationTimeout = new TimeSpan(0, 15, 0);
            CrmServiceClient.MaxConnectionTimeout = TimeSpan.FromMinutes(15);

            for (int n = 0; n < partitions.Count - 1; n++)
            {
                var deleteRequest = new DeleteAuditDataRequest();
                deleteRequest.EndDate = new DateTime(2000, 1, 1);
                if (partitions[n].EndDate < DateTime.Now && partitions[n].EndDate > deleteRequest.EndDate)
                {
                    deleteRequest.EndDate = (DateTime)partitions[n].EndDate;

                    // Delete the audit records.
                    if (deleteRequest.EndDate != new DateTime(2000, 1, 1))
                    {
                        _crmServiceClient.Execute(deleteRequest);
                    }
                }
            }

            _eventStream.OnNext(new DeploymentEvent()
            {
                Message = "Older Audit Logs deletion-Complete",
                State = DeploymentEvent.OperationState.Completed,
                Type = DeploymentEvent.OperationType.RecordUpdate,
                Level = DeploymentEvent.LogLevel.Info
            });

        }

        /// <summary>
        /// Deactivate Views specified in the XElement Data
        /// </summary>
        public void DeactivateViews()
        {
            XElement systemViewsForDeactivation = ConfigData.Root.Element("ViewsForDeactivation");

            if (systemViewsForDeactivation != null)
            {
                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Deactivating Views (" +
                        systemViewsForDeactivation.Elements("Queue").Count() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordDeactivate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                foreach (var v in systemViewsForDeactivation.Descendants("View"))
                {
                    try
                    {
                        bool updateViewStatus = _crmServiceClient.UpdateStateAndStatusForEntity("savedquery", new Guid(v.Attribute("id").Value), 1, 2);

                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message = "Deactivated View: " + v.Attribute("id") + " - response was " + updateViewStatus,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordDeactivate,
                            Level = DeploymentEvent.LogLevel.Verbose
                        });
                    }
                    catch (Exception ex)
                    {
                        _eventStream.OnNext(new DeploymentEvent()
                        {
                            Message = "Failed to deactivate view: " + v.Attribute("id") + " Error: " + ex.Message,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordDeactivate,
                            Level = DeploymentEvent.LogLevel.Warning
                        });
                    }
                }
            }

            _eventStream.OnNext(new DeploymentEvent()
            {
                Message = "Deactivating Views Completed",
                State = DeploymentEvent.OperationState.Completed,
                Type = DeploymentEvent.OperationType.RecordDeactivate,
                Level = DeploymentEvent.LogLevel.Info
            });
        }

        /// <summary>
        /// Update Service called by import service
        /// </summary>
        private void UpdateWebServiceResource(Entity webServiceResource)
        {
            string name = webServiceResource.Attributes["sfa_name"].ToString();

            webServiceResource.Id = GetWebServiceResourceId(name);

            var request = new UpdateRequest()
            {
                Target = webServiceResource
            };

            _crmServiceClient.ExecuteCrmOrganizationRequest(request);
        }



        /// <summary>
        /// DeploymentMode specified in the XElement Data
        /// </summary>
        public DeploymentMode GetDeploymentMode()
        {
            DeploymentMode result = DeploymentMode.ReleaseDeployment;

            XElement deploymentMode = ConfigData.Root.Element("DeploymentMode");

            if (deploymentMode != null)
            {
                try
                {
                    string dMode = deploymentMode.Element("Value").Value;

                    _eventStream.OnNext(new DeploymentEvent()
                    {
                        Message = "Deployment : " + dMode,
                        State = DeploymentEvent.OperationState.InProgress,
                        Type = DeploymentEvent.OperationType.RecordDeactivate,
                        Level = DeploymentEvent.LogLevel.Verbose
                    });

                    switch (dMode)
                    {
                        case "1":
                            result = DeploymentMode.FullDeployment;
                            break;
                        case "2":
                            result = DeploymentMode.RestoreDeployment;
                            break;
                        case "4":
                            result = DeploymentMode.ServicesDeployment;
                            break;
                        default:
                            result = DeploymentMode.ReleaseDeployment;
                            break;

                    }




                }
                catch (Exception ex)
                {
                    _eventStream.OnNext(new DeploymentEvent()
                    {
                        Message = "Failed to get Deployment Mode. Error: " + ex.Message,
                        State = DeploymentEvent.OperationState.InProgress,
                        Type = DeploymentEvent.OperationType.RecordDeactivate,
                        Level = DeploymentEvent.LogLevel.Warning
                    });
                }

            }

            return result;
        }









        /// <summary>
        /// Get the record from the specified filter criteria
        /// </summary>
        /// <param name="filterField">Filter to be applied</param>
        /// <param name="queryField">Field to be queried by filter</param>
        /// <param name="entityType">Logical name of the entity</param>
        /// <param name="returnColumnName">Return column name (ID)</param>
        /// <returns>The Guid of the record</returns>
        private Guid GetRecordId(string filterField, string queryField, string entityType, string returnColumnName)
        {
            // Checks whether the Record NAme is null or zero length
            if (string.IsNullOrEmpty(filterField))
            {
                throw new Exception("Error While retrieving Guid of entity " + entityType + " - Parameters invalid.");
            }

            var qba = new QueryByAttribute(entityType);

            qba.AddAttributeValue(queryField, filterField);

            // Values need to be retrieved is the Guid of the entity requested
            qba.ColumnSet = new ColumnSet(returnColumnName, "createdon");

            var request = new RetrieveMultipleRequest { Query = qba };

            EntityCollection entCol =
                (_crmServiceClient.ExecuteCrmOrganizationRequest(request) as RetrieveMultipleResponse)
                    .EntityCollection;

            // Retrieve the value based on the condition given
            var recordDetails = entCol.Entities;

            // Return the Guid of the record
            if (recordDetails.Count == 1 && recordDetails[0] != null)
            {
                var returnGuid = new Guid(recordDetails[0].Id.ToString());
                return returnGuid;
            }

            throw new Exception("Error While retrieving Guid of entity " + entityType);
        }

        /// <summary>
        /// Overloaded method to filter by two parameters (used for looking up user roles by name and BU)
        /// </summary>
        /// <param name="filterField1">First filter</param>
        /// <param name="queryField1">Field to be queried by first filter</param>
        /// <param name="entityType">Logical name of the entity</param>
        /// <param name="returnColumnName">Return column name (ID)</param>
        /// <param name="filterField2">Second filter</param>
        /// <param name="queryField2">Field to be queried by second filter</param>
        /// <returns>The guid of the record</returns>
        private Guid GetRecordId(string filterField1, string queryField1, string entityType, string returnColumnName, string filterField2, string queryField2)
        {
            // Checks whether the Record Name is null or zero length
            if (string.IsNullOrEmpty(filterField1) || string.IsNullOrEmpty(filterField2))
            {
                throw new Exception("Error While retrieving Guid of entity " + entityType + " - Parameters invalid.");
            }

            var qba = new QueryByAttribute(entityType);

            // Condition parameters
            qba.AddAttributeValue(queryField1, filterField1);

            // Second condiiton parameter - used for Business Unit filtering
            qba.AddAttributeValue(queryField2, GetBusinessUnitId(filterField2));

            // Value need to be retrieved is the Guid of Record
            qba.ColumnSet = new ColumnSet(returnColumnName, "createdon");

            DataCollection<Entity> recordDetails;

            var request = new RetrieveMultipleRequest();
            request.Query = qba;

            EntityCollection entCol =
                (_crmServiceClient.ExecuteCrmOrganizationRequest(request) as RetrieveMultipleResponse)
                    .EntityCollection;

            // Retrieve the value based on the condition given
            recordDetails = entCol.Entities;

            // Return the Guid of the record
            if (recordDetails.Count == 1 && recordDetails[0] != null)
            {
                return new Guid(recordDetails[0].Id.ToString());
            }

            throw new Exception("Error While retrieving Guid of entity " + entityType);
        }

        /// <summary>
        /// Retrieve business unit ID by business unit name
        /// </summary>
        /// <param name="businessUnitName">The name of the business unit</param>
        /// <returns>The business unit guid</returns>
        private Guid GetBusinessUnitId(string businessUnitName)
        {
            try
            {
                //return GetRecordId(businessUnitName, "name", "businessunit", "businessunitid");
                return GetDefaultBusinessUnitId(); //select first one due to CRM online copy not setting correct name
            }
            catch (Exception ex)
            {
                throw new Exception("Error While retrieving Guid of Business Unit : " + ex.Message);
            }
        }

        /// <summary>
        /// Retrieve default business unit ID (first)
        /// </summary>
        /// <param></param>
        /// <returns>The business unit guid</returns>
        private Guid GetDefaultBusinessUnitId()
        {
            try
            {
                Guid businessUnitId = Guid.Empty;
                QueryExpression query = new QueryExpression("businessunit");
                string[] cols = { "businessunitid", "name" };
                query.Criteria = new FilterExpression();
                query.Criteria.AddCondition("name", ConditionOperator.NotNull);
                query.ColumnSet = new ColumnSet(cols);
                var request = new RetrieveMultipleRequest { Query = query };

                EntityCollection entCol =
                        (_crmServiceClient.Execute(request) as RetrieveMultipleResponse).EntityCollection;

                if (entCol.Entities.Count == 1)
                {
                    businessUnitId = (Guid)entCol.Entities[0].Attributes["businessunitid"];
                    return businessUnitId;
                }
                throw new Exception("Error While retrieving Guid of entity " + "businessunit");
            }
            catch (Exception ex)
            {
                throw new Exception("Error While retrieving Guid of Default Business Unit : " + ex.Message);
            }
        }

        /// <summary>
        /// Retrieve system user id by domain name
        /// </summary>
        /// <param name="strDomainName">The Domain Name (DOMAIN\LOGON) of the system user</param>
        /// <returns>THe system user guid</returns>
        private Guid GetSystemUserId(string strDomainName)
        {
            try
            {
                return GetRecordId(strDomainName, "domainname", "systemuser", "systemuserid");
            }
            catch (Exception ex)
            {
                throw new Exception("Error While retrieving Guid of User " + ex.Message);
            }
        }

        /// <summary>
        /// Retrieve Service id by name
        /// </summary>
        /// <param name="strServiceName">The name of the web service resource</param>
        /// <returns>The webserviceresource  guid</returns>
        private Guid GetWebServiceResourceId(string strServiceName)
        {
            try
            {
                return GetRecordId(strServiceName, "sfa_name", "sfa_webserviceresource", "sfa_webserviceresourceid");
            }
            catch (Exception)
            {
                return Guid.Empty;
            }
        }

        /// <summary>
        /// Retrieve Queue id by name
        /// </summary>
        /// <param name="strQueueName">The name of the queue</param>
        /// <returns>The queue guid</returns>
        private Guid GetQueueId(string strQueueName)
        {
            try
            {
                return GetRecordId(strQueueName, "name", "queue", "queueid");
            }
            catch (Exception ex)
            {
                throw new Exception("Error While retrieving Guid of User " + ex.Message);
            }
        }

        /// <summary>
        /// Retrieve Security Role by business unit and name
        /// </summary>
        /// <param name="strRoleName">The name of the security role</param>
        /// <param name="strBusinessUnitName">The name of the business unit</param>
        /// <returns>The security role guid</returns>
        private Guid GetRoleId(string strRoleName, string strBusinessUnitName)
        {
            try
            {
                return GetRecordId(strRoleName, "name", "role", "roleid", strBusinessUnitName, "businessunitid");
            }
            catch (Exception ex)
            {
                throw new Exception("Error While retrieving Guid of Role " + ex.Message);
            }
        }

        /// <summary>
        /// Retrieve Team by name
        /// </summary>
        /// <param name="strTeamName">The name of the team</param>
        /// <returns>The team guid</returns>
        private Guid GetTeamId(string strTeamName)
        {
            try
            {
                return GetRecordId(strTeamName, "name", "team", "teamid");
            }
            catch (Exception ex)
            {
                throw new Exception("Error While retrieving Guid of Team " + ex.Message);
            }
        }

        /// <summary>
        /// Creates a business unit with the specified name and parent business unit
        /// </summary>
        /// <param name="strParentName">Name of the parent business unit</param>
        /// <param name="strName">Name of the business unit</param>
        /// <returns>The guid of the newly created business unit</returns>
        private Guid CreateBusinessUnit(string strParentName, string strName)
        {
            try
            {
                var e = new Entity("businessunit");
                e.Attributes["name"] = strName;

                // Check for the valid Guid. If it is not a guid retrieve the guid based on the name of the business unit
                Guid parentGuid = GetBusinessUnitId(strParentName);

                // If Guid Exists then place it into the ParentBusinessUnitId lookup field of BusinessUnit entity
                EntityReference refParentBusinessUnit = new EntityReference("businessunit", parentGuid);
                e.Attributes["parentbusinessunitid"] = refParentBusinessUnit;

                CreateRequest request = new CreateRequest();
                request.Target = e;
                CreateResponse response = (CreateResponse)_crmServiceClient.ExecuteCrmOrganizationRequest(request);

                // Create Business Unit
                Guid businessUnitGuid = response.id;

                return businessUnitGuid;
            }
            catch (Exception ex)
            {
                throw new Exception("Error While Creating a Business Unit :  " + strName + ". Error Message: " + ex.Message);
            }
        }

        /// <summary>
        /// Creates a system user with the details specified in the entity parameter, in the business unit specified. 
        /// </summary>
        /// <param name="userEntity">An entity object corresponding to the system user to be created</param>
        /// <param name="businessUnit">The name of the users business unit</param>
        /// <param name="roles">The roles to be assigned to the user</param>
        /// <returns>The guid of the newly created business unit</returns>
        private Guid CreateSystemUser(Entity userEntity, string businessUnit, XElement roles)
        {
            try
            {
                var request = new CreateRequest { Target = userEntity };

                CreateResponse response = (CreateResponse)_crmServiceClient.ExecuteCrmOrganizationRequest(request);
                Guid systemUserGuid;
                if (_crmServiceClient.LastCrmException != null)
                {
                    if ((_crmServiceClient.LastCrmException.Message != "An object with the specified name already exists.")
                        && (_crmServiceClient.LastCrmException.Message != "Cannot insert duplicate key.")
                        && (_crmServiceClient.LastCrmException.Message != "The specified Active Directory user already exists as a CRM user."))
                    {
                        throw _crmServiceClient.LastCrmException;
                    }

                    systemUserGuid = GetRecordId(
                        userEntity.Attributes["domainname"].ToString(),
                        "domainname",
                        "systemuser",
                        "systemuserid");
                }
                else
                {
                    // Create System User
                    systemUserGuid = response.id;
                }

                // Import Roles for User - Pass System User and BU Guid and Roles collection
                CreateRolesForUser(systemUserGuid, userEntity.Attributes["domainname"].ToString(), businessUnit, roles);

                return systemUserGuid;
            }
            catch (Exception ex)
            {
                throw new Exception("Error While creating system user " + userEntity.Attributes["domainname"] + " - " + ex.Message);
            }
        }

        /// <summary>
        /// Updates a system user with the details specified in the entity parameter, in the business unit specified. 
        /// </summary>
        /// <param name="userEntity">An entity object corresponding to the system user to be updated</param>
        private void UpdateSystemUser(Entity userEntity)
        {
            var request = new UpdateRequest()
            {
                Target = userEntity
            };

            _crmServiceClient.ExecuteCrmOrganizationRequest(request);
        }

        private void UpdateTransition(string transitionName, string managersTeam, string ownerTeam)
        {
            var transitionId = GetRecordId(transitionName, "sfa_name", "sfa_transition", "sfa_transitionid");

            var ownerTeamId = GetRecordId(ownerTeam, "name", "team", "teamid");

            var assignRequest = new AssignRequest
            {
                Assignee = new EntityReference("team", ownerTeamId),
                Target = new EntityReference("sfa_transition", transitionId)
            };
            _crmServiceClient.ExecuteCrmOrganizationRequest(assignRequest);

            if (!string.IsNullOrEmpty(managersTeam))
            {
                var managersTeamId = GetRecordId(managersTeam, "name", "team", "teamid");

                var entity = new Entity("sfa_transition")
                {
                    Id = transitionId,
                    Attributes = new AttributeCollection()
                };

                entity.Attributes.Add("sfa_managersteam", new EntityReference("team", managersTeamId));

                var request = new UpdateRequest()
                {
                    Target = entity
                };

                _crmServiceClient.ExecuteCrmOrganizationRequest(request);
            }
        }

        private void UpdateTaskAction(string taskActionName, string taskActionTeam)
        {
            var taskActionId = GetRecordId(taskActionName, "sfa_taskname", "sfa_taskaction", "sfa_taskactionid");

            var taskActionTeamId = GetRecordId(taskActionTeam, "name", "team", "teamid");

            var entity = new Entity("sfa_taskaction")
            {
                Id = taskActionId,
                Attributes = new AttributeCollection()
            };

            entity.Attributes.Add("sfa_actionteamid", new EntityReference("team", taskActionTeamId));

            var request = new UpdateRequest()
            {
                Target = entity
            };

            _crmServiceClient.ExecuteCrmOrganizationRequest(request);
        }


        private void UpdateTerminationSelection(string SelectionName, string SelectionTeam)
        {
            var terminationSelectionId = GetRecordId(SelectionName, "sfa_name", "sfa_terminationselectionaction", "sfa_terminationselectionactionid");

            var terminationSelectionTeamId = GetRecordId(SelectionTeam, "name", "team", "teamid");

            var entity = new Entity("sfa_terminationselectionaction")
            {
                Id = terminationSelectionId,
                Attributes = new AttributeCollection()
            };

            entity.Attributes.Add("ownerid", new EntityReference("team", terminationSelectionTeamId));

            var request = new UpdateRequest()
            {
                Target = entity
            };

            _crmServiceClient.ExecuteCrmOrganizationRequest(request);
        }




        private void RemoveRedundantRecord(string EntityType, string RecordName)
        {
            var RecordId = GetRecordId(RecordName, "sfa_name", EntityType, EntityType + "id");

            if (RecordId != null)
            {
                _crmServiceClient.DeleteEntity(EntityType, RecordId);
            }


        }

        /// <summary>
        /// Assigns appropriate roles to the system user specified 
        /// </summary>
        /// <param name="systemUser">The guid of the system user</param>
        /// <param name="systemUserName">The domain name of the system user</param>
        /// <param name="businessUnit">The business unit of the system user</param>
        /// <param name="systemUserRoleData">An XElement consisting of the user roles to be assigned</param>
        private void CreateRolesForUser(Guid systemUser, string systemUserName, string businessUnit, XContainer systemUserRoleData)
        {
            try
            {
                var roles = new EntityReferenceCollection();

                var systemUserRoles = from item in systemUserRoleData.Descendants("Role")
                                      select new EntityReference("role", GetRoleId(item.Attribute("name").Value, businessUnit));

                foreach (var sur in systemUserRoles)
                {
                    roles.Add(sur);

                }

                var associateRequest = new AssociateRequest
                {
                    Target = new EntityReference("systemuser", systemUser),
                    Relationship = new Relationship("systemuserroles_association"),
                    RelatedEntities = roles
                };

                _crmServiceClient.ExecuteCrmOrganizationRequest(associateRequest);
            }
            catch (Exception ex)
            {
                throw new Exception("Error While associating system user roles for user: " + systemUserName + " - " + ex.Message);
            }
        }

        /// <summary>
        /// Creates Service Reference for a web resource 
        /// </summary>
        private Guid CreateWebResourceService(Entity webResourceEntity)
        {
            Guid guidToReturn = Guid.Empty;
            try
            {
                if (webResourceEntity != null)
                {
                    CreateRequest request = new CreateRequest();
                    request.Target = webResourceEntity;
                    CreateResponse response = (CreateResponse)_crmServiceClient.ExecuteCrmOrganizationRequest(request);
                    guidToReturn = response.id;
                }
            }
            catch (Exception ex)
            {
                if (webResourceEntity != null)
                {
                    throw new Exception("Error While creating web resource: " + webResourceEntity.Attributes["sfa_name"] + " - " + ex.Message);
                }
            }

            return guidToReturn;
        }

        /// <summary>
        /// Assigns designated roles for a team
        /// </summary>
        /// <param name="team">The Guid of the team</param>
        /// <param name="businessUnit">The name of the teams business unit</param>
        /// <param name="teamRoleData">An XElement object consisting of the roles to be assigned</param>
        private void CreateRolesForTeam(Guid team, string businessUnit, XElement teamRoleData)
        {
            try
            {
                var roles = new EntityReferenceCollection();

                var teamRoles = from item in teamRoleData.Descendants("Role")
                                select new EntityReference("role", this.GetRoleId(item.Attribute("name").Value, businessUnit));

                foreach (var sur in teamRoles)
                {
                    roles.Add(sur);
                }

                var associateRequest = new AssociateRequest
                {
                    Target = new EntityReference("team", team),
                    Relationship = new Relationship("teamroles_association"),
                    RelatedEntities = roles
                };

                _crmServiceClient.ExecuteCrmOrganizationRequest(associateRequest);
            }
            catch (Exception ex)
            {
                throw new Exception("Error While associating team roles " + ex.Message);
            }
        }

        /// <summary>
        /// Creates a new team based on the parameters provided
        /// </summary>
        /// <param name="strBUName">Name of the business unit</param>
        /// <param name="strTeamName">Name of the team</param>
        /// <param name="administratorName">Domain name of the teams administrator</param>
        /// <param name="teamMembers">An XElement consisting of of the members of the team</param>
        /// <param name="teamRoles">An XElement consisting of the roles to be assigned to the team</param>
        /// <returns>The guid of the newly created team</returns>
        private Guid CreateTeam(string strBUName, string strTeamName, string administratorName, XContainer teamMembers, XElement teamRoles)
        {
            try
            {
                Guid systemUserId = GetSystemUserId(administratorName);
                Guid businessUnitId = GetBusinessUnitId(strBUName);
                Guid teamId = GetRecordId(strTeamName, "name", "team", "teamid");

                if (teamId == Guid.Empty)
                {
                    var e = new Entity("team");
                    e.Attributes["name"] = strTeamName;
                    e.Attributes["administratorid"] = new EntityReference("systemuser", systemUserId);
                    e.Attributes["businessunitid"] = new EntityReference("businessunit", businessUnitId);
                    e.Attributes["teamtype"] = new OptionSetValue(0);

                    var request = new CreateRequest()
                    {
                        Target = e
                    };

                    CreateResponse response = (CreateResponse)_crmServiceClient.ExecuteCrmOrganizationRequest(request);

                    if (_crmServiceClient.LastCrmException != null)
                    {

                        if ((_crmServiceClient.LastCrmException.Message).Contains("Duplicate record exists"))
                        {
                            teamId = response.id;
                        }
                        else if
                            (_crmServiceClient.LastCrmException.Message !=
                             "An object with the specified name already exists." &&
                             _crmServiceClient.LastCrmException.Message !=
                             "The specified Active Directory user already exists as a CRM user")
                        {
                            throw _crmServiceClient.LastCrmException;
                        }
                        else
                        {
                            teamId = GetRecordId(strTeamName, "name", "team", "teamid");
                        }
                    }
                    else
                    {
                        teamId = response.id;
                    }
                }
                CreateTeamMembers(teamId, teamMembers);

                CreateRolesForTeam(teamId, strBUName, teamRoles);

                return teamId;
            }
            catch (Exception ex)
            {
                throw new Exception("Cannot create team Error : " + ex.Message);
            }
        }

        /// <summary>
        /// Creates team members based on team guid and XContainer
        /// </summary>
        /// <param name="teamId">The Guid of the team</param>
        /// <param name="teamMembers">An XContainer consisting of of the members of the team</param>
        private void CreateTeamMembers(Guid teamId, XContainer teamMembers)
        {
            try
            {
                Guid[] membersId = (from item in teamMembers.Descendants("Member")
                                    let systemUserId = GetSystemUserId(item.Attribute("domainname").Value)
                                    select systemUserId).ToArray();

                var addTeamRequest = new AddMembersTeamRequest
                {
                    TeamId = teamId,
                    MemberIds = membersId
                };

                // Execute request
                _crmServiceClient.ExecuteCrmOrganizationRequest(addTeamRequest);
            }
            catch (Exception ex)
            {
                throw new Exception("Error While adding members for team. Error Message: " + ex.Message);
            }
        }

        /// <summary>
        /// Creates a queue based on the name provided
        /// </summary>
        /// <param name="queue">An entity object representing the queue to be created</param>
        /// <returns>The guid of the newly created queue</returns>
        private Guid CreateQueue(Entity queue)
        {
            try
            {
                var request = new CreateRequest { Target = queue };
                CreateResponse response = (CreateResponse)_crmServiceClient.ExecuteCrmOrganizationRequest(request);
                var queueId = new Guid();
                if (_crmServiceClient.LastCrmException != null)
                {
                    if (_crmServiceClient.LastCrmException.Message != "An object with the specified name already exists.")
                    {
                        throw _crmServiceClient.LastCrmException;
                    }
                }
                else
                {
                    // Create Queue
                    queueId = response.id;
                }

                return queueId;
            }
            catch (Exception ex)
            {
                throw new Exception("Error While creating Queue: " + queue.Attributes["name"] + " - " + ex.Message);
            }
        }

        private void UpdateSystemSettings(XContainer systemSettingsXml)
        {
            var wmiRequest = new WhoAmIRequest();

            var wmiResponse = (WhoAmIResponse)_crmServiceClient.ExecuteCrmOrganizationRequest(wmiRequest);

            var orgId = wmiResponse.OrganizationId;

            var orgCols = new ColumnSet("dateformatstring", "timeformatstring", "localeid");

            var retOrgRequest = new RetrieveRequest
            {
                ColumnSet = orgCols,
                Target = new EntityReference("organization", orgId)
            };

            var org = ((RetrieveResponse)_crmServiceClient.ExecuteCrmOrganizationRequest(retOrgRequest)).Entity;

            var dateFormatElement = systemSettingsXml.Element("DateFormat");

            if (dateFormatElement != null)
            {
                org.Attributes["dateformatstring"] = dateFormatElement.Value;
            }

            var timeoutElement = systemSettingsXml.Element("TimeFormat");

            if (timeoutElement != null)
            {
                org.Attributes["timeformatstring"] = timeoutElement.Value;
            }

            var localeElement = systemSettingsXml.Element("LocaleId");

            if (localeElement != null)
            {
                org.Attributes["localeid"] = int.Parse(localeElement.Value);
            }

            var autoSaveElement = systemSettingsXml.Element("AutoSave");
            org.Attributes["isautosaveenabled"] = autoSaveElement != null && bool.Parse(autoSaveElement.Value);
            var auditElement = systemSettingsXml.Element("AuditEnabled");
            org.Attributes["isauditenabled"] = auditElement != null && bool.Parse(auditElement.Value);

            var updateOrgRequest = new UpdateRequest { Target = org };

            _crmServiceClient.ExecuteCrmOrganizationRequest(updateOrgRequest);
        }

        public void UpdateUserDataFormat()
        {
            var wmiRequest = new WhoAmIRequest();

            var wmiResponse = (WhoAmIResponse)_crmServiceClient.ExecuteCrmOrganizationRequest(wmiRequest);

            var userCols = new ColumnSet("dateformatstring", "timeformatstring", "localeid");

            var retUserSettingsRequest = new RetrieveRequest
            {
                ColumnSet = userCols,
                Target = new EntityReference("usersettings", wmiResponse.UserId)
            };

            var userSettings =
                ((RetrieveResponse)_crmServiceClient.ExecuteCrmOrganizationRequest(retUserSettingsRequest)).Entity;

            foreach (var timeZoneSetting in _utcTimeZoneSettings)
            {
                userSettings.Attributes[timeZoneSetting.Key] = timeZoneSetting.Value;
            }

            var updateUserSettingsRequest = new UpdateRequest { Target = userSettings };

            _crmServiceClient.ExecuteCrmOrganizationRequest(updateUserSettingsRequest);
        }

        public void ActivateWorkflow(string solutionName)
        {
            //Publish Workflows

            //Get Draft workflow from Specific Solution - Previously activate workflow step may accidentally activate any draft workflow in Default solution
            //Since we join the workflow with solution component entity, it will only activate any draft workflow if it belongs to "CIBERSFAFCTSolution" solution
            //Integration test is in CRMConsoleApp

            // get solution components for solution unique name
            QueryExpression componentsQuery = new QueryExpression
            {
                EntityName = "solutioncomponent",
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression(),
            };
            LinkEntity solutionLink = new LinkEntity("solutioncomponent", "solution", "solutionid", "solutionid", JoinOperator.Inner);
            solutionLink.LinkCriteria = new FilterExpression();
            solutionLink.LinkCriteria.AddCondition(new ConditionExpression("uniquename", ConditionOperator.Equal, solutionName));
            componentsQuery.LinkEntities.Add(solutionLink);
            componentsQuery.Criteria.AddCondition(new ConditionExpression("componenttype", ConditionOperator.Equal, 29));

            var request1 = new RetrieveMultipleRequest();
            request1.Query = componentsQuery;

            EntityCollection ComponentsResult = ((RetrieveMultipleResponse)_crmServiceClient.ExecuteCrmOrganizationRequest(request1)).EntityCollection;

            QueryExpression workflowQuery = new QueryExpression("workflow")
            {
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };

            //activate workflow, dialog and action
            int[] values = new int[] { 0, 1, 3 };

            ConditionExpression condition1 = new ConditionExpression("statecode", ConditionOperator.Equal, 0);
            ConditionExpression condition2 = new ConditionExpression("category", ConditionOperator.In, values);
            ConditionExpression condition3 = new ConditionExpression("type", ConditionOperator.Equal, 1);
            ConditionExpression condition4 = new ConditionExpression("rendererobjecttypecode", ConditionOperator.Null);
            workflowQuery.Criteria.AddCondition(condition1);
            workflowQuery.Criteria.AddCondition(condition2);
            workflowQuery.Criteria.AddCondition(condition3);
            workflowQuery.Criteria.AddCondition(condition4);

            var request = new RetrieveMultipleRequest();
            request.Query = workflowQuery;

            var workflows = _crmServiceClient.ExecuteCrmOrganizationRequest(request);

            var workflowlist = ((RetrieveMultipleResponse)workflows).EntityCollection.Entities.Join(ComponentsResult.Entities.Select(x => x.Attributes["objectid"]), x => x.Id, y => y, (x, y) => x);
            //Join entities Id and solution Components Id 

            foreach (Entity workflow in workflowlist.ToList())
            {
                _eventStream.OnNext(new DeploymentEvent()
                {
                    Message =
                        "Activate Workflow (" +
                        workflow["name"].ToString() +
                        ")",
                    State = DeploymentEvent.OperationState.Started,
                    Type = DeploymentEvent.OperationType.RecordCreate,
                    Level = DeploymentEvent.LogLevel.Info
                });

                try
                {
                    var activateRequest = new SetStateRequest
                    {
                        EntityMoniker = new EntityReference
                            (workflow.LogicalName, workflow.Id),
                        State = new OptionSetValue(1),
                        Status = new OptionSetValue(2)
                    };

                    _crmServiceClient.ExecuteCrmOrganizationRequest(activateRequest);


                }
                catch (Exception ex)
                {
                    _eventStream.OnNext(new DeploymentEvent()
                    {
                        Message =
                            "Failed to active workflow: " + workflow["name"] + " Error: " + ex.Message,
                        State = DeploymentEvent.OperationState.InProgress,
                        Type = DeploymentEvent.OperationType.RecordCreate,
                        Level = DeploymentEvent.LogLevel.Warning
                    });
                }

            }

        }





        #endregion
    }

    public enum DeploymentMode
    {
        FullDeployment = 1,
        RestoreDeployment = 2,
        ReleaseDeployment = 3,
        ServicesDeployment = 4
    }
}