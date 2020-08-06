# <a href="#required-fields">Required Fields</a>

- [File Name](#file-name)
- [Title](#title)
- [Item ARK](#item-ark)
- [Parent ARK](#parent-ark) (required for `Work` and `Page` objects)
- [Object Type](#object-type)
- [Rights.copyrightStatus](#rights.copyrightstatus)

# <a href="#other-allowed-fields">Other Allowed Fields</a>

- [AltIdentifier.local](#altidentifier.local)
- [AltTitle.other](#alttitle.other)
- [AltTitle.uniform](#alttitle.uniform)
- [Author](#author)
- [Binding note](#binding_note)
- [Calligrapher](# calligrapher)
- [Collation](#collation)
- [Colophon](#colophon)
- [Commentator](#commentator)
- [Condition note](#condition_note)
- [Coverage.geographic](#coverage.geographic)
- [Date.creation](#date.creation)
- [Date.normalized](#date.normalized)
- [Description.caption](#description.caption)
- [Description.fundingNote](#description.fundingnote)
- [Description.latitude](#description.latitude)
- [Description.longitude](#description.longitude)
- [Description.note](#description.note)
- [Editor](# editor)
- [Engraver](# engraver)
- [Foliation](#foliation)
- [Featured image](#featured_image)
- [Finding Aid Url](#finding-aid-url)creator
- [Format.dimensions](#format.dimensions)
- [Format.extent](#format.extent)
- [Format.medium](#format.medium)
- [viewingHint](#viewingHint)
- [IIIF Access URL](#iiif-access-url)
- [IIIF Range](#iiif-range)
- [Illustrations note](#illustrations-note)
- [Illustrator](#illustrator)
- [Item Sequence](#item-sequence)
- [Language](#language)
- [License](#license)
- [Masthead](#masthead_parameters)
- [Name.architect](#name.architect)
- [Name.composer](#name.composer)
- [Name.creator](#name.creator)
- [Name.illuminator](#name.illuminator)
- [Name.lyricist](#lyricist)
- [Name.photographer](#name.photographer)
- [Name.repository](#name.repository)
- [Name.scribe](#name.scribe)
- [Name.subject](#name.subject)
- [Note](#note)
- [Opac url](#opac_url)
- [Page layout](#page-layout)
- [Printmaker](# printmaker)
- [Project Name](#project-name)
- [Place of origin](#place-of-origin)
- [Provenance](#provenance)
- [Publisher.publisherName](#publisher.publishername)
- [Relation.isPartOf](#relation.ispartof)
- [Representative image](#representative_image)
- [Rights.countryCreation](#rights.countrycreation)
- [Rights.rightsHolderContact](#rights.rightsholdercontact)
- [Rubricator](#rubricator)
- [Rights.statementLocal](#rights.statementLocal)
- [Subject](#subject)
- [Subject.conceptTopic](#subject.concept_topic)
- [Subject.descriptiveTopic](#subject.descriptive_topic)
- [Subject geographic](#subject_geographic)
- [Subject temporal](#subject_temporal)
- [Summary](#summary)
- [Support](#support)
- [Tagline](#tagline)
- [IIIF Text direction](#iiif_text_direction)
- [Table of Contents](#table-of-contents)
- [Translator](#translator)
- [Type.genre](#type.genre)
- [Type.typeOfResource](#type.typeofresource)
- [Visibility](#visibility)

## Required Fields

### File Name (required)

A _full file path_ to the file in the "Masters" NetApp volume. Currently this must be single-valued. If a `Work` has multiple files associated with it, then each file should be given its own line with the object type `Page` and a `Parent ARK` value that refers to the parent `Work`.

If the File Name starts with "Masters/", it will be used as is. Otherwise, it will be prepended with `Masters/dlmasters/`, in order to match the content of DLCS exports.

This field is a string. **This field is required**.

Examples:

- `Masters/dlmasters/postcards/masters/21198-zz00090ntn-1-master.tif`
- `postcards/masters/21198-zz00090nn2-1-master.tif`
  <br> (Imported as `Masters/dlmasters/postcards/masters/21198-zz00090nn2-1-master.tif`)
- `Masters/DLTempSecure/ABC/xyz/file_123.tif`

### Title (required)

A name to aid in identifying a work.

This field is a string. **This field is required**.

Examples:

- `[Fannie Lou Hamer, Mississippi Freedom Democratic Party delegate, at the Democratic National Convention, Atlantic City, New Jersey, August 1964] / [WKL].` (single value)
<!-- - `[Fannie Lou Hamer, Mississippi Freedom Democratic Party delegate, at the Democratic National Convention, Atlantic City, New Jersey, August 1964] / [WKL].|~|Fannie Lou Hamer Portrait` (multivalued) -->

If the title begins with 'DUPLICATE' (case sensitive), then no new record will be created. If a record already exists with the same ARK, then that record will be updated as usual. Such records can be found and manually deleted by searching for 'DUPLICATE'.

### Item ARK (required)

A persistent unique identifier associated with a work. It takes the form `ark:/shoulder/blade` where `shoulder` is an institutional identifier, and `blade` is a work identifier. Every work and collection in Californica must have an ark value. The ark is not multivalued -- each work can only have one.

This field is a string. **This field is required**.

Examples:

- `ark:/21198/zz002h2fpt` (single value)

### Parent ARK (required)

The ARK value of the object's hierarchical parent. For a single-image `Work` object, this will be the ARK of a `Collection` object. For `Page` objects, this will be the ARK of the parent `Work` object.

This field is a string. **This field is required for Work objects**.

Examples:

- `ark:/21198/zz002h2fpt` (single value)

### Object Type (required)

A controlled vocabulary term referring to the type of repository object that will be created for this CSV row. Current legal values are `Collection`, `Work`, and `Page`. Only one value can be given per CSV row.

Currently, `Manuscript` is also accepted as a synonym of `Work`, and `ChildWork` as accepted as a synonym of `Page`, but this functionality may be removed at some point in the future.

This field is a string. **This field is required**.

Examples:

- `Work` (single value)
- `Page` (single value)

### Rights.copyrightStatus (required)

The copyright status of this work. The only currently allowed value is `copyrighted`.

This field is a string. **This field is required**.

Examples:

- `copyrighted` (single value)

## Other Allowed Fields

### AltIdentifier.local

A local identifier. Can be multivalued.

Also accepts: `Alternate Identifier.local`, `AltIdentifier.callNo`, `Alt ID.local`, `Local identifier`

Examples:

- `uclamss_686_b6_f24_18` (single value)
- `uclamss_686_b6_f24_18|~|uclamss_abc1234` (multivalued)

### AltTitle.other

Also accepts: `AltTitle.translated`, `AltTitle.descriptive`

### AltTitle.uniform

### Author

### Binding note

Also accepts: `Description.binding`

### Calligrapher

Also accepts Name.calligrapher

### Collation

### Colophon

Also accepts: `Description.colophon`

### Commentator

Also accepts: `Name.commentator`

### Condition note

Also accepts: `Description.condition`

### Coverage.geographic

### Date.creation

### Date.normalized

### Description.caption

### Description.fundingNote

### Description.latitude

### Description.longitude

### Description.note

### Editor

Also accepts Name.editor

### Engraver

Also accepts Name.engraver

### Featured image

### Finding Aid URL

Also accepts: `Alt ID.url`

### Foliation

Also accepts: `Foliation note`

### Format.dimensions

### Format.extent

### Format.medium

### IIIF Access URL

The URL of a IIIF resource that can be used to view the image. This is populated by processing the CSV via [bucketeer](https://bucketeer.library.ucla.edu/upload/csv)

### IIIF Range

### Illuminator

Also aaccepts: `Name.illuminator`

### Illustrations note

Also accepts: `Description.illustrations`

### Illustrator

accepts ""Illustrator", "Name.illustrator"

### Item Sequence

### viewingHint

### Language

### License

### Masthead

### Name.architect

### Name.composer

### Name.creator

### Name.lyricist

### Name.photographer

### Note

### Repository

Also accepts: `Name.repository`

### Name.scribe

### Opac url

Also accepts: `Description.opac`

### Page layout

### Place of origin

### Printmaker

Also accepts Name.printmaker

### Project Name

### Provenance

Also accepts: `Description.history`

### Publisher.publisherName

### Relation.isPartOf

### Representative image

### Rights.countryCreation

### Rights.rightsHolderContact

### Rights.statementLocal

### Rubricator

Also accepts: `Name.rubricator`

### Subject name

Also accepts: `Personal or Corporate Name.subject`, `Subject.corporateName`, `Subject.personalName`, `Name.subject`

### Subject topic

Also accepts: `Subject.conceptTopic` ; `Subject.descriptiveTopic`

### Subject geographic

### Subject temporal

### Summary

Also accepts: `Description.abstract`

### Support

### IIIF Text direction

### Table of Contents

Also accepts: `Description.tableOfContents`

### Tagline

### Translator

Also accepts: `Name.translator`

### Type.genre

Also accepts: `Genre`

### Type.typeOfResource

### Visibility

A single-value field that must contain one of the allowed values.

This field is not required. If the value is left blank, it will default to `public` visibility. If you omit the column, this will trigger a more complicated procedure to determine the visibility of DLCS imports (see below).

Examples:

- `public` - All users can view the record
- `authenticated` - Logged in users can view the record
- `sinai` - For Sinai Library items. All californica users can view the metadata, but not the files. Hidden from the public-facing site as of Nov 2019.
- `discovery` - A synonym `sinai`. Not recommended for new data.
- `private` - Only admin users or users who have been granted special permission may view the record

If there is no column with the header "Visibility", then the importer will look for the field "Item Status". Visibility will be made `public` if the status is "Completed" or
"Completed with minimal metadata", or (by default) if the column cannot be found or is blank for a row.

"Item Status" is _only_ used if "Visiblity" is completely omitted from the csv. If the column is included but left blank, then a default of `public` will be applied to a row regardless of any "Item Status" value.
