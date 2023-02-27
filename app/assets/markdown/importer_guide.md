# <a href="#required-fields">Required Fields</a>
<!-- TOC START min:1 max:4 link:true asterisk:false update:true -->

- [Required Fields](#required-fields)
    - [File Name (required)](#file-name-required)
    - [Title (required)](#title-required)
    - [Item ARK (required)](#item-ark-required)
    - [Parent ARK (required)](#parent-ark-required)
    - [Object Type (required)](#object-type-required)
    - [Rights.copyrightStatus (required)](#rightscopyrightstatus-required)

# <a href="#other-allowed-fields">Other Supported Fields</a>

- [Other Supported Fields](#other-supported-fields)
    - [AltTitle.other](#alttitleother)
    - [AltTitle.uniform](#alttitleuniform)
    - [Author](#author)
    - [Binding note](#binding-note)
    - [Collation](#collation)
    - [Colophon](#colophon)
    - [Condition note](#condition-note)
    - [Content disclaimer](#contentdisclaimer)
    - [Contents note](#contents-note)
    - [Coverage.geographic](#coveragegeographic)
    - [Date.created](#datecreated)
    - [Date.normalized](#datenormalized)
    - [Description.caption](#descriptioncaption)
    - [Description.fundingNote](#descriptionfundingnote)
    - [Description.latitude](#descriptionlatitude)
    - [Description.longitude](#descriptionlongitude)
    - [Description.note](#descriptionnote)
    - [Featured image (not in use)](#featured-image-not-in-use)
    - [Finding Aid URL](#finding-aid-url)
    - [Foliation](#foliation)
    - [Format.dimensions](#formatdimensions)
    - [Format.extent](#formatextent)
    - [Format.medium](#formatmedium)
    - [Genre](#genre)
    - [IIIF Access URL](#iiif-access-url)
    - [IIIF Range (for future use in Festerize to generate Ranges)](#iiif-range-for-future-use-in-festerize-to-generate-ranges)
    - [Illustrations note](#illustrations-note)
    - [Item Sequence](#item-sequence)
    - [Language](#language)
    - [License](#license)
    - [Local identifier](#local-identifier)
    - [Masthead](#masthead)
    - [Name.architect](#namearchitect)
    - [Name.artist](#nameartist)
    - [Name.calligrapher](#namecalligrapher)
    - [Name.cartographer](#namecartographer)
    - [Name.commentator](#namecommentator)
    - [Name.composer](#namecomposer)
    - [Name.creator](#namecreator)
    - [Name.director](#namedirector)
    - [Name.editor](#nameeditor)
    - [Name.engraver](#nameengraver)
    - [Name.illuminator](#nameilluminator)
    - [Name.illustrator](#nameillustrator)
    - [Name.interviewee](#nameinterviewee) 
    - [Name.interviewer](#nameinterviewer) 
    - [Name.lyricist](#namelyricist)
    - [Name.photographer](#namephotographer)
    - [Name.printmaker](#nameprintmaker)
    - [Name.producer](#nameproducer)
    - [Name.recipient](#namerecipient)
    - [Name.rubricator](#namerubricator)
    - [Name.scribe](#namescribe)
    - [Name.translator](#nametranslator)
    - [Note](#note)
    - [Opac url](#opac-url)
    - [Page layout](#page-layout)
    - [Place of origin](#place-of-origin)
    - [Program](#program)
    - [Project Name](#project-name)
    - [Provenance](#provenance)
    - [Publisher.publisherName](#publisherpublishername)
    - [Relation.isPartOf](#relationispartof)
    - [Repository](#repository)
    - [Representative image](#representative-image)
    - [Rights.countryCreation](#rightscountrycreation)
    - [Rights.rightsHolderContact](#rightsrightsholdercontact)
    - [Rights.statementLocal](#rightsstatementlocal)
    - [Series](#series)
    - [Subject geographic](#subject-geographic)
    - [Subject name](#subject-name)
    - [Subject temporal](#subject-temporal)
    - [Subject culturalObject](#subject-culturalobject)
    - [Subject domainTopic](#subject-domaintopic)
    - [Subject topic](#subject-topic)
    - [Summary](#summary)
    - [Support](#support)
    - [Text direction (for Festerize only)](#text-direction-for-festerize-only)
    - [Table of Contents](#table-of-contents)
    - [Tagline](#tagline)
    - [Thumbnail](#thumbnail)
    - [Type.typeOfResource](#typetypeofresource)
    - [viewingHint (for Festerize only)](#viewinghint-for-festerize-only)
    - [Visibility](#visibility)
<!-- TOC END -->

## Required Fields

### File Name (required)

A _full file path_ to the file on NetApp, beginning with the NetApp volume in the form `Masters/...`. This must be single-valued. If a `Work` has multiple files associated with it, then each file should be given its own line with the object type `Page` and a `Parent ARK` value that refers to the parent `Work`.

`Masters/...` is an alias referring to `masters.in.library.ucla.edu/...`, the volume root. Objects exported from DLCS will likely have a file path that begins with the project folder (ex. `postcards/`); In these cases, as long as these project folders are in `Masters/dlmasters/...` the full path is prepended on ingest. All other file paths must begin with `Masters/...`.

For all formats, any number of leading `/` characters will be ignored.

This field is a string. **This field is required** although the values will likely be blank for complex works where the file paths are included only in the `Page` rows.

Examples:

- `Masters/dlmasters/postcards/masters/21198-zz00090nrm-1-master.tif`
  <br> (Imported as `masters.in.library.ucla.edu/dlmasters/postcards/masters/21198-zz00090ntn-1-master.tif`)
- `postcards/masters/21198-zz00090nn2-1-master.tif`
  <br> (Imported as `masters.in.library.ucla.edu/dlmasters/postcards/masters/21198-zz00090nn2-1-master.tif`)
- `Masters/othermasters/dl_toganoo/masters/ucla_1240878_v1/ucla_1240878_vol1_001.tif`
  <br> (Imported as `masters.in.library.ucla.edu/othermasters/dl_toganoo/masters/ucla_1240878_v1/ucla_1240878_vol1_001.tif`)
- `//othermount.in.library.ucla.edu/ABC/xyz/file_123.tif`
  <br> (Imported as `othermount.in.library.ucla.edu/ABC/xyz/file_123.tif`)

### Title (required)

A name to aid in identifying a work.

This field is a string. **This field is required**. This field is single-valued.

Examples:

- `[Fannie Lou Hamer, Mississippi Freedom Democratic Party delegate, at the Democratic National Convention, Atlantic City, New Jersey, August 1964] / [WKL].` (single value)

If the title begins with 'DUPLICATE' (case sensitive), then no new record will be created. If a record already exists with the same ARK, then that record will be updated as usual. Such records can be found and manually deleted in the CSV by searching for 'DUPLICATE'.

### Item ARK (required)

A persistent unique identifier associated with a work. It takes the form `ark:/shoulder/blade` where `shoulder` is an institutional identifier, and `blade` is a work identifier. Every work and collection in Californica must have an ark value. The ark is not multivalued -- each work can only have one.

This field is a string. **This field is required**.

Examples:

- `ark:/21198/zz002h2fpt` (single value)

### Parent ARK (required)

The ARK value of the object's hierarchical parent. For a single-image `Work` object, this will be the ARK of a `Collection` object. For `Page` objects, this will be the ARK of the parent `Work` object.

This field is a string. **This field is required for Work and Page objects**. This field can be multi-valued when a work belongs to more than one collection.

Examples:

- `ark:/21198/zz002h2fpt` (single value)

### Object Type (required)

A controlled vocabulary term referring to the type of repository object that will be created for this CSV row. Current legal values are `Collection`, `Work`, and `Page`. Only one value can be given per CSV row.

Currently, `Manuscript` is also accepted as a synonym of `Work`, and `ChildWork` as accepted as a synonym of `Page`, but these terms do not work with Festerize and may be removed at some point in the future.

This field is a string. **This field is required**.

Examples:

- `Work` (single value)
- `Page` (single value)

### Rights.copyrightStatus (required)

The copyright status of this work. The only currently allowed value is `copyrighted`.

This field is a string. **This field is required to be present in the CSV, but a value is not required**.

Examples:

- `copyrighted` (single value)

<!----------------------------->
## Other Supported Fields

#### AltTitle.other

A translated, alternative, or other title that is not the primary or uniform title.

Also accepts: `AltTitle.translated`, `AltTitle.descriptive`, `AltTitle.parallel`, `Alternate Title.descriptive`, `Alternate Title.inscribed`, `AltTitle.descriptive`, `Alternate Title.other`

#### AltTitle.uniform

A uniform title from a controlled vocabulary. Can be multivalued.

#### Author

The author of the work being described. Can be multivalued.

#### Binding note

Also accepts: `Description.binding`

#### Collation

#### Colophon

A transcription or translation of a colophon, or a not on the location of a book or manuscript's colophon.

Also accepts: `Description.colophon`

#### Condition note

Also accepts: `Description.condition`

#### Content disclaimer

#### Contents note

#### Coverage.geographic

A place that represents the geographic coverage of an item, such as circulation of a newspaper. For place as a subject, see `Subject.geographic`.

#### Date.created

A human-readable date that is displayed to the user.

Also accepts: `Date.creation`

#### Date.normalized

A machine-readable date following the format `yyyy-mm-dd` for single dates, `yyyy-mm-dd/yyyy-mm-dd` for date ranges.

#### Description.caption

A transcription of a caption on a photograph or other type of item.

#### Description.fundingNote

#### Description.latitude

#### Description.longitude

#### Description.note

A general description of the item begin described. This field is displayed on the search results page.

#### Featured image (not in use)

#### Finding Aid URL

Also accepts: `Alt ID.url`

#### Foliation

Also accepts: `Foliation note`

#### Format.dimensions

#### Format.extent

#### Format.medium

#### Genre

Also accepts: `Type.genre`

#### IIIF Access URL

The URL of a IIIF resource that can be used to view the image. This is populated by processing the CSV via [bucketeer](https://bucketeer.library.ucla.edu/upload/csv). This URL is used to generate thumbnails for simple objects.

_Note: Complex objects generally do not have IIIF Access URLs in the Work rows, so require the `Thumbnail URL` field to generate thumbnails._

#### IIIF Range (for future use in Festerize to generate Ranges)

#### Illustrations note

Also accepts: `Description.illustrations`

#### Item Sequence

Required for Page rows of complex objects to generate manifests using Festerize. Work rows should not have Item Sequence values.

#### Language

Language of the resource. Must be the 3-letter ISO 639-2 code. Can be multivalued.

#### License

#### Local identifier

A local identifier. Can be multivalued.

Also accepts: `Alternate Identifier.local`, `AltIdentifier.callNo`, `Alt ID.local`, `AltIdentifier.local`

Examples:

- `uclamss_686_b6_f24_18` (single value)
- `uclamss_686_b6_f24_18|~|uclamss_abc1234` (multivalued)

#### Masthead

The IIIF parameters following a IIIF image base URL. Used for the masthead image on a collections page. See `Representative image` below.

#### Name.architect

#### Name.artist

Also accepts: `Artist

#### Name.calligrapher

Also accepts `Calligrapher`

#### Name.cartographer

Also accepts: `Cartographer`

#### Name.commentator

Also accepts: `Commentator`

#### Name.composer

#### Name.creator

Also accepts: `Creator`

#### Name.director 

Also accepts: `Director`

#### Name.editor

Also accepts: `Editor`

#### Name.engraver

Also accepts: `Engraver`

#### Name.illuminator

Also accepts: `Illuminator`

#### Name.illustrator

Also accepts: `Illustrator`

#### Name.Interviewee

Also accepts: `Interviewee`

#### Name.Interviewer

Also accepts: `Interviewee`

#### Name.lyricist

#### Name.photographer

Also accepts: `Personal or Corporate Name.photographer`

#### Name.printmaker

Also accepts: `Printmaker`

#### Name.producer

Also accepts: `Producer`

#### Name.recipient

Also accepts: `Recipient`

#### Name.rubricator

Also accepts: `Rubricator`

#### Name.scribe

#### Name.translator

Also accepts: `Translator`

#### Note

#### Opac url

Also accepts: `Description.opac`

#### Page layout

#### Place of origin

Also accepts: `Publisher.placeOfOrigin`

#### Program

#### Project Name

This field is exported from DLCS and is the DLCS project name.

#### Provenance

Also accepts: `Description.history`

#### Publisher.publisherName

#### Relation.isPartOf

DLCS collection name

#### Repository

Also accepts: `Name.repository`, `repository`, `Personal or Corporate Name.repository`

#### Representative image

The base URL of a IIIF image to be used for the collection page masthead. See `Masthead` above.

#### Rights.countryCreation

#### Rights.rightsHolderContact

Also accepts: `Rights.rightsHolderName`, `Personal or Corporate Name.copyrightHolder`

#### Rights.statementLocal

#### Series

#### Subject geographic

Also accepts: `Subject place`

#### Subject name

Also accepts: `Name.subject`, `Personal or Corporate Name.subject`, `Subject.corporateName`, `Subject.personalName`

#### Subject temporal

#### Subject culturalObject

#### Subject domainTopic

#### Subject topic

Also accepts: `Subject.conceptTopic`, `Subject.descriptiveTopic`

#### Summary

The Summary field can be used for Collections and Works. This field is the primary "about" field displayed on Collection pages.

Also accepts: `Description.abstract`

#### Support

The material or substrate on which content is written.

#### Text direction (for Festerize only)

Used to set the text reading direction in the IIIF manifest for display in viewer. Values include: `left-to-right` (default), `right-to-left`, `top-to-bottom`, `bottom-to-top`.

#### Table of Contents

Also accepts: `Description.tableOfContents`

#### Tagline

#### Thumbnail

URL for an image to be used as the thumbnail. Must be the stem of a IIIF Image API resource of the form `{scheme}://{server}{/prefix}/{identifier}`, omitting all other Image API parameters. For example: `https://iiif.library.ucla.edu/iiif/2/ark%3A%2F21198%2Fz1k667gp`.

For simple image objects, the thumbnail is pulled from the [`IIIF Access URL`](#iiif-access-url), however for other content types such as multi-image or audiovisual works, thumbnail values will need to be supplied since there is no IIIF Access URL.

[`IIIF Access URL`](#iiif-access-url) is populated by processing the CSV via [bucketeer](https://bucketeer.library.ucla.edu/upload/csv)

#### Type.typeOfResource

Controlled term list. Can be multivalued.

#### viewingHint (for Festerize only)

Used to set the viewing behavior of an object in the IIIF manifest for display in viewers. Values include: `paged`, `individuals`, `continuous`.

#### Visibility

A single-value field that can be empty, or if a value is present, must use one of the allowed values.

If the value is left blank, it will default to `public` visibility. If you omit the column, this will trigger a more complicated procedure to determine the visibility of DLCS imports (see below).

Examples:

- `public` - All users can view the record
- `authenticated` - Logged in users can view the record
- `sinai` - For Sinai Library items. All californica users can view the metadata, but not the files. Hidden from the public-facing site as of Nov 2019.
- `discovery` - A synonym `sinai`. Not recommended for new data.
- `private` - Only admin users or users who have been granted special permission may view the record

If there is no column with the header "Visibility", then the importer will look for the field "Item Status". Visibility will be made `public` if the status is "Completed" or
"Completed with minimal metadata", or (by default) if the column cannot be found or is blank for a row.

"Item Status" is _only_ used if "Visiblity" is completely omitted from the csv. If the column is included but left blank, then a default of `public` will be applied to a row regardless of any "Item Status" value.
