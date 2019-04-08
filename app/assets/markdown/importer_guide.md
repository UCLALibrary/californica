# <a href="#required-fields">Required Fields</a>
* [File Name](#file-name)
* [Item Ark](#item-ark)
* [Object Type](#object-type)
* [Parent ARK](#parent-ark) (required for `Work` objects)
* [Rights.copyrightStatus](#rights.copyrightstatus)
* [Title](#title)

# <a href="#other-allowed-fields">Other Allowed Fields</a>
* [AltIdentifier.local](#altidentifier.local)
* [Coverage.geographic](#coverage.geographic)
* [Date.creation](#date.creation)
* [Date.normalized](#date.normalized)
* [Description.caption](#description.caption)
* [Description.fundingNote](#description.fundingnote)
* [Description.latitude](#description.latitude)
* [Description.longitude](#description.longitude)
* [Description.note](#description.note)
* [Format.dimensions](#format.dimensions)
* [Format.extent](#format.extent)
* [Format.medium](#format.medium)
* [Language](#language)
* [Name.photographer](#name.photographer)
* [Name.repository](#name.repository)
* [Name.subject](#name.subject)
* [Project Name](#project-name)
* [Publisher.publisherName](#publisher.publishername)
* [Relation.isPartOf](#relation.ispartof)
* [Rights.countryCreation](#rights.countrycreation)
* [Rights.rightsHolderContact](#rights.rightsholdercontact)
* [Subject](#subject)
* [Type.genre](#type.genre)
* [Type.typeOfResource](#type.typeofresource)

## Required Fields

### File Name (required)
A filename to attach to the object. Can be multivalued.

This field is a string.  **This field is required**.

Examples:

* `clusc_1_1_00010432a.tif` (single value)
* `clusc_1_1_00010432a.tif|~|clusc_1_1_00010432b.tif` (multivalued)

### Item Ark (required)

A persistent unique identifier associated with a work. It takes the form `ark:/shoulder/blade` where `shoulder` is an institutional identifier, and `blade` is a work identifier. Every work and collection in Californica must have an ark value. The ark is not multivalued -- each work can only have one.

This field is a string.  **This field is required**.

Examples:

* `ark:/21198/zz002h2fpt` (single value)

### Object Type (required)

A controlled vocabulary term referring to the type of repository object that will be created for this CSV row. Current legal values are `Collection` and `Work`. Only one value can be given per CSV row.

This field is a string.  **This field is required**.

Examples:

* `Work` (single value)

### Parent ARK (required)

The ark value of this object's hierarchical parent. For a single-image `Work` object, this will be the ark of a `Collection` object. When we start importing multi-page objects, this will become more complex.

This field is a string.  **This field is required for Work objects**.

Examples:

* `ark:/21198/zz002h2fpt` (single value)

### Rights.copyrightStatus (required)

The copyright status of this work. The only currently allowed value is `copyrighted`.

This field is a string.  **This field is required**.

Examples:

* `copyrighted` (single value)

### Title (required)

A name to aid in identifying a work.

This field is a string.  **This field is required**.

Examples:

* `[Fannie Lou Hamer, Mississippi Freedom Democratic Party delegate, at the Democratic National Convention, Atlantic City, New Jersey, August 1964] / [WKL].` (single value)
* `[Fannie Lou Hamer, Mississippi Freedom Democratic Party delegate, at the Democratic National Convention, Atlantic City, New Jersey, August 1964] / [WKL].|~|Fannie Lou Hamer Portrait` (multivalued)

## Other Allowed Fields

### AltIdentifier.local
A local identifier. Can be multivalued.

Examples:

* `uclamss_686_b6_f24_18` (single value)
* `uclamss_686_b6_f24_18|~|uclamss_abc1234` (multivalued)

### Coverage.geographic
### Date.creation
### Date.normalized
### Description.caption
### Description.fundingNote
### Description.latitude
### Description.longitude
### Description.note
### Format.dimensions
### Format.extent
### Format.medium
### Language
### Name.photographer
### Name.repository
### Name.subject
### Project Name
### Publisher.publisherName
### Relation.isPartOf
### Rights.countryCreation
### Rights.rightsHolderContact
### Subject
### Type.genre
### Type.typeOfResource