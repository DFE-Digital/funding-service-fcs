namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Infrastructure.DTO;
    using Infrastructure.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using TechTalk.SpecFlow;
    using Utilities;
    using SFA.FCT.Contracts.AcceptanceTests.Extensions;

    [Binding]
    public class WorkflowSteps
    {
        [Given(@"the workflow history on contract '(.*)' version '(.*)' includes the following")]
        [Then(@"the workflow history on contract '(.*)' version '(.*)' includes the following")]
        public void ThenTheWorkflowHistoryOnContractVersionIncludesTheFollowing(TransformedString contractNumber, int version, Table table)
        {
            IReadOnlyCollection<WorkflowHistory> requestedWorkflowHistories = table.Rows.Select(r => new WorkflowHistory(r["Action"], r["CompletedBy"], r.ParseNullableString("Comment"))).ToList();
            IReadOnlyCollection<WorkflowHistory> actualWorkflowHistories = Enumerable.Empty<WorkflowHistory>().ToList();

            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                actualWorkflowHistories =
                    CrmWorkflowHistoryRepository.GetWorkflowHistoryItemsForContract(contractNumber.ToString(), version);

                return requestedWorkflowHistories.All(req => actualWorkflowHistories.Contains(req));
            },
            maxNumChecks: 40,
            waitIntervalSeconds: 4);

            bool areWorkflowHistoriesPresent =
                checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTimeWithGenericSqlErrorTolerance();

            Assert.IsTrue(areWorkflowHistoriesPresent, "We have not found all the workflow histories - " + requestedWorkflowHistories.FirstOrDefault(req => !actualWorkflowHistories.Contains(req)));
        }

        [Then(@"the workflow history on contract '(.*)' version '(.*)' includes '(.*)' entry which matches the following")]
        [Then(@"the workflow history on contract '(.*)' version '(.*)' includes '(.*)' entries which match the following")]
        public void ThenTheWorkflowHistoryOnContractVersionIncludesEntriesWhichMatchTheFollowing(TransformedString contractNumber, int version, int count, Table table)
        {
            IReadOnlyCollection<WorkflowHistory> requestedWorkflowHistories = table.Rows.Select(r => new WorkflowHistory(r["Action"], r["CompletedBy"], r.ParseNullableString("Comment"))).ToList();
            IReadOnlyCollection<WorkflowHistory> actualWorkflowHistories = Enumerable.Empty<WorkflowHistory>().ToList();

            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                actualWorkflowHistories =
                    CrmWorkflowHistoryRepository.GetWorkflowHistoryItemsForContract(contractNumber.ToString(), version);

                return requestedWorkflowHistories.All(req => actualWorkflowHistories.Count(awh => awh.Equals(req)) == count);
            },
            maxNumChecks: 20,
            waitIntervalSeconds: 3);

            bool areWorkflowHistoriesPresent =
                checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTimeWithGenericSqlErrorTolerance();

            Assert.AreEqual(true, areWorkflowHistoriesPresent, 
                "We have not found all the workflow histories - " 
                    + requestedWorkflowHistories.FirstOrDefault(req => actualWorkflowHistories.Count(awh => awh.Equals(req)) != count));
        }

        [When(@"a request is raised by Advisor '(.*)' to close version '(.*)' of contract '(.*)' for provider '(.*)'")]
        [Given(@"a request is raised by Advisor '(.*)' to close version '(.*)' of contract '(.*)' for provider '(.*)'")]
        public void WhenARequestIsRaisedByToCloseVersionOfContractForProvider(string userName, int version, TransformedString contractNumber, int ukprn)
        {
            const string workflowName = "WF30 Contract: End Contract on Closure";
           
            Guid workflowId = CrmWorkflowRepository.GetWorkFlowId(workflowName);
            Guid contractId = CrmContractRepository.GetMostRecentByContractId(contractNumber.ToString(), version);
           
            Guid userId = CrmUserRepository.GetUserId(userName);
            CrmContractRepository.SetTaskOwnerOnContract(contractId, userId);

            CrmWorkflowRepository.ExecuteWorkFlow(workflowId, contractId, userName);
        }

        [When(@"a request is raised by Manager '(.*)' to Approve Closure of version '(.*)' of contract '(.*)' for provider '(.*)'")]
        public void WhenARequestIsRaisedByManagerToApproveClosureOfVersionOfContractForProvider(string userName, int version, TransformedString contractNumber, int ukprn)
        {
            Guid contractId = CrmContractRepository.GetMostRecentByContractId(contractNumber.ToString(), version);

            Guid transitionId = CrmTransitionRepository.GetTransitionId("Approve Closure");

            CrmContractRepository.SetTransitionOnContract(contractId, transitionId, userName);
        }

        [When(@"a request is raised by Manager '(.*)' to Reject Closure of version '(.*)' of contract '(.*)' for provider '(.*)' for the following reason")]
        [Given(@"a request is raised by Manager '(.*)' to Reject Closure of version '(.*)' of contract '(.*)' for provider '(.*)' for the following reason")]
        public void WhenARequestIsRaisedByManagerToRejectClosureOfVersionOfContractForProviderForTheFollowingReason(string userName, int version, TransformedString contractNumber, int ukprn, Table table)
        {
            string reasonText = table.Rows[0]["RejectionReason"];

            CrmContractRepository.SetNextActionWithReasonForRejection("Reject Closure", contractNumber.ToString(), version, userName, reasonText);
        }


        [Then(@"all Tasks against version '(.*)' of contract '(.*)' for provider '(.*)' have their state and status set to Completed")]
        [Given(@"all Tasks against version '(.*)' of contract '(.*)' for provider '(.*)' have their state and status set to Completed")]
        public void ThenAllTasksAgainstVersionOfContractForProviderHaveTheirStateAndStatusSetToCompleted(int version, TransformedString contractNumber, int ukprn)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                IReadOnlyCollection<TaskInfo>  taskInfos = CrmContractRepository.GetTasksForContract(contractNumber.ToString(), version);
                return taskInfos.All(t => t.State == "Completed" && t.Status == "Completed");
            },
            maxNumChecks: 20,
            waitIntervalSeconds: 3);

            bool allTasksAreComplete = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            Assert.IsTrue(allTasksAreComplete, $"Not all tasks are complete for this contract: {contractNumber}, version: {version}");
        }

        [Given(@"the following Tasks are present against version '(.*)' of contract '(.*)' for provider '(.*)'")]
        [Given(@"the following new Task has been created against version '(.*)' of contract '(.*)' for provider '(.*)'")]
        [Then(@"the following new Task has been created against version '(.*)' of contract '(.*)' for provider '(.*)'")]
        [Then(@"the following Tasks are present against version '(.*)' of contract '(.*)' for provider '(.*)'")]
        public void ThenTheFollowingNewTaskHasBeenCreatedAgainstVersionOfContractForProvider(int version, TransformedString contractNumber, int ukprn, TransformedTable table)
        {
            IReadOnlyCollection<TaskInfo> requestedTasks = 
                table.Rows.Select(r => 
                    new TaskInfo
                    {
                        Name = r["Task"],
                        Description = r["Description"],
                        AssignedTeam = r["Assigned Team"],
                        Owner = r["Owner"],
                        State = r["State"],
                        Status = r["Status"]
                    }).ToList();

            requestedTasks.ForEach(t => t.AssignedTeam = (t.AssignedTeam == "?") ? string.Empty: t.AssignedTeam);

            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                IReadOnlyCollection<TaskInfo> actualTaskInfos =
                    CrmContractRepository.GetTasksForContract(contractNumber.ToString(), version);

                return requestedTasks.All(req => actualTaskInfos.Contains(req));
            },
           maxNumChecks: 30,
           waitIntervalSeconds: 3);

            bool areWorkflowHistoriesPresent =
                checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTimeWithGenericSqlErrorTolerance();

            Assert.AreEqual(true, areWorkflowHistoriesPresent, "We have not found all the Tasks");
        }

        [When(@"the following open Task currently linked to version '(.*)' of contract '(.*)' for provider '(.*)' is triggered by User '(.*)'")]
        public void WhenTheFollowingOpenTaskCurrentlyLinkedToVersionOfContractForProviderIsTriggered(int version, TransformedString contractNumber, int ukprn, string userName, TransformedTable table)
        {
            IEnumerable<SimpleTask> expectedTasks = table.Rows.Select(r => new SimpleTask(r["Task"], r["Owner"])).ToList();

            IReadOnlyCollection<TaskInfo> openTasksForContract = CrmContractRepository.GetTasksForContract(contractNumber.Value, version).ToList();
            List<SimpleTask> openSimpleTasksForContract = openTasksForContract.Where(t => t.State == "Open")
                .Select(t => new SimpleTask(t.Name, t.Owner)).ToList();
            
            SimpleTask missingTaskInfo = expectedTasks.FirstOrDefault(t => !openSimpleTasksForContract.Contains(t));
            Assert.IsTrue(expectedTasks.All(exp => openSimpleTasksForContract.Contains(exp)), "Task not found. " + missingTaskInfo ?? "");


            var matchingTaskInfos = openTasksForContract.Where(openTask => expectedTasks.Select(exp => exp.TaskName).Contains(openTask.Name)).ToList();
            matchingTaskInfos.ForEach(t =>
            {
                CrmTaskRepository.UpdateTaskToCompleteForUser(t.Id, userName);
            });
        }

        [Given(@"the following workflow histories against version '(.*)' of contract '(.*)' are removed")]
        public void GivenTheFollowingWorkflowHistoriesAgainstVersionOfContractAreRemoved(int contractVersionNumber, TransformedString contractNumber, TransformedTable table)
        {
            table.Rows.ForEach(row =>
                CrmWorkflowHistoryRepository.DeleteMatchingWorkflowHistories(
                    contractNumber: contractNumber.Value,
                    contractVersionNumber: contractVersionNumber,
                    action: row["Action"],
                    completedBy: row["CompletedBy"],
                    comments: row.ParseNullableString("Comment"))
            );
        }

        [Then(@"the Workflow History for version '(.*)' of contract '(.*)' includes the following")]
        public void ThenTheWorkflowHistoryForVersionOfContractIncludesTheFollowing(int contractVersionNumber, TransformedString contractNumber, TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                CheckResultPoller poller = new CheckResultPoller(
                    checkResult: () =>
                    {
                        IReadOnlyCollection<sfa_contracttransitionhistory> workflowHistoryItems =
                            CrmWorkflowHistoryRepository.GetWorkflowHistory(contractNumber.Value, contractVersionNumber);

                        return workflowHistoryItems.Any(wfh =>
                        {
                            return row["Action"] == wfh.sfa_Action.Name &&
                                   row["CompletedBy"] == wfh.sfa_Actionby.Name &&
                                   string.Compare(row.ParseNullableString("NewContractOwner"), wfh.sfa_NewContractOwner,
                                       StringComparison.InvariantCultureIgnoreCase) == 0 &&
                                   row["NewTaskOwner"] == wfh.sfa_newowner &&
                                   row.ParseEnum<sfa_contractstatus>("NewStatus") == wfh.sfa_NewStatusEnum &&
                                   row["NewSubStatus"] == wfh.sfa_NewSubStatus.Name &&
                                   row.ParseNullableString("PreviousContractOwner") == wfh.sfa_PreviousContractOwner &&
                                   row.ParseNullableString("PreviousTaskOwner") == wfh.sfa_previousowner &&
                                   (sfa_contractstatus?) row.ParseNullableEnum<sfa_contractstatus>("PreviousStatus") ==
                                   wfh.sfa_PreviousStatusEnum &&
                                   row.ParseNullableString("PreviousSubStatus") == wfh.sfa_PreviousSubStatus?.Name;
                        });

                    },
                    maxNumChecks: 20,
                    waitIntervalSeconds: 3);

                bool foundMatchingWorkflowHistoryItem = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsTrue(foundMatchingWorkflowHistoryItem, $"Could not find matching workflow history item for {row.ToHeaderAndValueString()}");
            });
        }

        [Given(@"the following Tasks are created against version '(.*)' of contract '(.*)' for UKPRN '(.*)'")]
        public void GivenTheFollowingTasksAreCreatedAgainstVersionOfContractForUKPRN(int versionNumber, TransformedString contractNumber, int ukprn, TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                Guid contractId = CrmContractRepository.GetMostRecentByContractId(contractNumber, versionNumber);

                Guid taskId = CrmTaskRepository.CreateTask(
                    row["Task"],
                    row["Description"],
                    new EntityReference(sfa_contract.EntityLogicalName, contractId),
                    row["Owner"],
                    row["Assigned Team"]
                );

                CrmContractRepository.SetCurrentTask(contractId, taskId);
            });
        }

        [Given(@"message '(.*)' is written to the Output window")]
        [When(@"message '(.*)' is written to the Output window")]
        [Then(@"message '(.*)' is written to the Output window")]
        public void GivenMessageIsWrittenToTheOutputWindow(TransformedString msg)
        {
            Console.WriteLine("\r\n" + msg + "\r\n");
        }

        private class SimpleTask
        {
            public SimpleTask(string taskName, string owner)
            {
                TaskName = taskName;
                Owner = owner;
            }

            protected bool Equals(SimpleTask other)
            {
                return string.Equals(TaskName, other.TaskName) && string.Compare(Owner, other.Owner, true, CultureInfo.InvariantCulture) == 0;
            }

            public override bool Equals(object obj)
            {
                if (ReferenceEquals(null, obj)) return false;
                if (ReferenceEquals(this, obj)) return true;
                if (obj.GetType() != this.GetType()) return false;
                return Equals((SimpleTask) obj);
            }

            public override int GetHashCode()
            {
                unchecked
                {
                    return ((TaskName != null ? TaskName.GetHashCode() : 0)*397) ^ (Owner != null ? Owner.GetHashCode() : 0);
                }
            }

            public string TaskName { get; }
            public string Owner { get; }

            public override string ToString()
            {
                return $"TaskName : {TaskName}, Owner: {Owner}";
            }
        }
    }
}
