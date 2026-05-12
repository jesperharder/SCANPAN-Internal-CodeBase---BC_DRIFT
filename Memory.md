# Memory

## Current Project State
- Repository: `SCANPAN Internal CodeBase - BC25`.
- App: `SCANPAN CODEBASE Internal Development`, version `1.0.26.4`, runtime `14.1`, platform `25.0.0.0`, target `OnPrem`, app id range `50000-50400`.
- Branch state checked 2026-05-06: `master` tracks `origin/master`; no merge is currently in progress and no unmerged files are present.
- Existing dirty worktree state includes changes in `.vscode/rad.json`, `app.json`, the built `.app` package, `SubscriberShipmondo.Codeunit.al`, several Claims pages, `src/page/al.al`, all three translation XLIFF files, and untracked tools `Compare-BcAppDependencyVersions.ps1` and `Find-TaskletPackageTypeDuplicates.ps1`.
- `Memory.md` was backed up before cleanup as `Memory.md.20260506-094757.bak`.
- Active BC central registry scope currently includes `BC25`, `BC25 Test`, `SCANPAN API-DW Cloud`, and `SCANPAN API-DW OnPrem`.

## Current Decisions And Contracts
- BC25-based projects are intended to become more cross-target and cloud-capable over time; `BC_DRIFT` and `BC_TEST` remain BC18 on-prem reference lines.
- Several sibling projects reuse the same AL app identity as parallel variants. Deployment and package selection must be checked carefully before publish.
- Production dashboard schema work must not modify existing table fields in place. Add replacement fields and obsolete replaced fields.
- Production dashboard redesign uses `table 50030 "Prod. Dashboard User Pref."`, `enum 50025 "Prod. Dashboard Chart ID"`, and codeunits `50035-50038` for preference, chart mapping, data building, and drilldown logic.
- Production dashboard redesign does not currently include migration of old saved preferences; users may reconfigure preferences after redesign.
- `table 50022 "UserSettingsPage"` is obsolete pending for the production dashboard preference scenario.
- For Tasklet PackAndShip package type dedupe, local code changes should only affect lookup construction/selection in `SubscriberShipmondo`; they must not modify BC business or setup table data.

## Open Blockers And Next Checks
- VS Code publish to `BC25TestUserPwd` reaches the developer endpoint, but failed with `UnprocessableEntity` because no license file is uploaded for that server/database. After the license issue is corrected, reset launch schema update mode to `Synchronize` if it still shows `forcesync`.
- `BC25UserPassword` developer publishing requires server-side service work: previous server check found `DeveloperServicesEnabled = false` while `DeveloperServicesPort = 7146`.
- `BC25UserPassword` has no separate IIS web client app in the verified server state; browser access should use the available mapped web apps unless server configuration changes.
- ForNAV validation against production `BC250` should recheck developer service/firewall availability if ForNAV needs the development endpoint.
- TrueCommerce TMO OData setup still needs environment-side clarification: the UI showed a `BC250` Windows/NTLM URL, while isolated connection tests produced `BC25UserPassword` Basic-auth events.
- Original `docs\bc25-instance-port-overview.pdf` was previously locked during update; `docs\bc25-instance-port-overview.updated.pdf` contains the regenerated output unless the original has since been replaced.

## Verified Environment Facts
- `docs\bc25-instance-port-overview.md` records validated BC25 service ports and web/OData/SOAP URL mappings.
- `BC25TestUserPwd` developer endpoint was reachable at publish time.
- `BC25UserPassword` SOAP/OData endpoints can authenticate successfully when valid Basic credentials are used; do not store those credentials in memory or docs.
- DynamicWeb `DWWebService` WSDL exposes `AddDynamicwebShippingItemCharge`, `CreateWebService`, `Execute`, `GetVersion`, `OnInstallAppPerCompany`, and `Process`.
- `PerfionPricesDW` is published in OData metadata and returns JSON when called with valid Basic credentials; browser authentication failures are client credential issues, not service publication or URL shape issues.
- BC25 production `BC250` installed app versions matched the project dependency targets for Tasklet, XtensionIT, and the SCANPAN app in the latest recorded server-side check.

## Verified Code And Data Findings
- Active Pack Type handling is in `src\codeunit\SubscriberShipmondo.Codeunit.al`; Tasklet/Shipmondo package type lookup is switched per warehouse shipment shipping agent and service using `MOB Mobile WMS Package Setup`.
- `src\page ext\MOBMobileWMSPackageSetup.PageExt.al` exposes shipping agent service code on the setup page.
- `src\codeunit\DSVAPI.Codeunit.al` contains `PackType` only in commented example JSON, not active shipment logic.
- Current XtensionIT dependencies in `app.json` are aligned with local BC25 symbol packages: Shipment Core `5.4.1.2500`, Shipmondo Connector `5.2.1.2500`, Shipment Extender for Tasklet Mobile WMS `4.2.0.2500`.
- Claims administration is consolidated on `page 50289 ClaimsAdmin`; the duplicate `page 50270 ClaimsSetupCard` was removed.
- Claims list explanatory text belongs on the related ListPart pages via page-level `InstructionalText`, not as separate parent-page FastTab text.
- Claims return reason translations support `DAN`, `ENG`, and `NOR`.
- Claims V3 login in `codeunit 50040 "ClaimsLoginMgt"` validates the submitted username against Customer `"Old Customer No."`; Customer Card shows `"Old Customer No."` in the Claims settings group as `Claims Username` / `Claims brugernavn`, while the old `ClaimsUser` page control is no longer used there.
- Danish translations should keep `Claims` as a working acronym and not translate it to `Reklamation`.
- XLIFF translation files are XLIFF 1.2. Current accepted translation state is no `[NAB:*]` targets, no `NAB AL Tool Refresh Xlf` notes, no multiple targets, and no missing/extra `trans-unit` IDs compared with the master `.g.xlf`.
- `Prod. Order Line` set-quantity maintenance runs before insert/modify in `SubscriberCU`, so set-quantity fields are written with the same production-order-line database operation.
- `src\page\WebServiceSalesPriceListSource.Page.al` is item-based and does not read sales campaigns.
- `src\page\WebServiceOrderFormItems.Page.al` and `src\page\SalespricelistDetailsSubPage.Page.al` read sales price lines for `Source Type = Customer Price Group` and do not implement the old campaign lookup against active campaign price lines.
- Legacy campaign logic matched item plus customer price group through campaign extension field `Customer Price Group NOTO`, likely from dependency app `Scanpan Base`.
- `src\page\CustomsDeclarationList.Page.al` Excel export uses `Excel Buffer` text-only headers; logo support exists in report `50002 "Customs Declaration"` but not in that page-driven Excel export.
- Report `50009 Faktura Varekoder` totals were fixed by moving total dataset columns to dataitem `Integer Total`.

## Candidate Cleanup Or Redesign Areas
- Static no-reference table candidates from active AL scan: `table 50016 "Field Selection Table"` (temporary), `table 50022 "UserSettingsPage"` (physical, obsolete pending), `table 50023 "VATEntriesBaseAmtSum"` (temporary), and `table 50027 "RecursiveBOMtemp"` (temporary). `table 50006 "PriceListSourceData"` is fully commented and is not an active schema object.
- Active obsolete fields without functional references include old Item purchase-price fields, `Customer.ShowCountryCode`, `Warehouse Shipment Header."Transport Order No."`, removed Sales Shipment Line transport/shipping fields, and old Country/Region `Market Type`/`Channel Type`.
- Additional non-obsolete no-reference candidates include `Customer.UseSalesNoSeries`, `Purchase Header."Transport API Sent"`, `Purchase Header."Transport API Sent date"`, `SalespriceListTMP.SourceNo`, `SalespriceListTMP.VatPct`, and `Address List."Address Line 3"`.
- Supply Chain PowerBI PBIP analysis supports building a BC-native `Supply Chain Cockpit` rather than cloning PowerBI. Strong first BC views are Inventory Warehouse, Availability by Period, Leveringsplan/Ordrebeholdning, and Lagerbevægelser.
- Supply Chain Cockpit phase 1 should focus on DK company and optionally NO via `ChangeCompany`, using cache/snapshot tables populated by Job Queue plus an `Update now` action.

## Documentation And Generated Outputs
- The current published BC manual source/output location is `C:\Users\jespe\Scanpan\Business Support - Dokumenter\Selvhjælp\001 - Vejledninger`.
- `docs\generate_bc25_manual.py` is the repeatable generator for the BC25 end-user manual.
- Generated manual visual assets live under `docs\generated_manual_assets`.
- `docs\generated_manual_assets\manual_cover_custom.png` is the persistent manual cover override for future manual generations.
