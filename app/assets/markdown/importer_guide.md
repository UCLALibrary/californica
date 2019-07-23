# <a href="#required-fields">Required Fields</a>

- [File Name](#file-name)
- [Item ARK](#item-ark)
- [Object Type](#object-type)
- [Parent ARK](#parent-ark) (required for `Work` objects)
- [Rights.copyrightStatus](#rights.copyrightstatus)
- [Title](#title)

# <a href="#other-allowed-fields">Other Allowed Fields</a>

- [AltIdentifier.local](#altidentifier.local)
- [AltTitle.other](#alttitle.other)
- [AltTitle.uniform](#alttitle.uniform)
- [Author](#author)
- [Coverage.geographic](#coverage.geographic)
- [Date.creation](#date.creation)
- [Date.normalized](#date.normalized)
- [Description.caption](#description.caption)
- [Description.fundingNote](#description.fundingnote)
- [Description.latitude](#description.latitude)
- [Description.longitude](#description.longitude)
- [Description.note](#description.note)
- [Format.dimensions](#format.dimensions)
- [Format.extent](#format.extent)
- [Format.medium](#format.medium)
- [Item Sequence](#item-sequence)
- [Language](#language)
- [Name.architect](#name.architect)
- [Name.photographer](#name.photographer)
- [Name.repository](#name.repository)
- [Name.subject](#name.subject)
- [Project Name](#project-name)
- [Place of origin](#place-of-origin)
- [Publisher.publisherName](#publisher.publishername)
- [Relation.isPartOf](#relation.ispartof)
- [Rights.countryCreation](#rights.countrycreation)
- [Rights.rightsHolderContact](#rights.rightsholdercontact)
- [Subject](#subject)
- [Summary](#summary)
- [Support](#support)
- [Type.genre](#type.genre)
- [Type.typeOfResource](#type.typeofresource)
- [Visibility](#visibility)

## Required Fields

### File Name (required)

A _full file path_ to the file in the "Masters" netapp volume. Currently this must be single-valued. If a Work has multiple files associated with it, then each file should be given its own line with object type of "ChildWork" and a "Parent ARK" value that refers to the original.

If the File Name starts with "Masters/", it will be used as is. Otherwise, it will be prepended with "Masters/dlmasters/", in order to match the content of DLCS exports.

This field is a string. **This field is required**.

Examples:

- `Masters/dlmasters/postcards/masters/21198-zz00090ntn-1-master.tif`
- `postcards/masters/21198-zz00090nn2-1-master.tif`
  <br> (Imported as `Masters/dlmasters/postcards/masters/21198-zz00090nn2-1-master.tif`)
- `Masters/DLTempSecure/ABC/xyz/file_123.tif`

### Item ARK (required)

A persistent unique identifier associated with a work. It takes the form `ark:/shoulder/blade` where `shoulder` is an institutional identifier, and `blade` is a work identifier. Every work and collection in Californica must have an ark value. The ark is not multivalued -- each work can only have one.

This field is a string. **This field is required**.

Examples:

- `ark:/21198/zz002h2fpt` (single value)

### Object Type (required)

A controlled vocabulary term referring to the type of repository object that will be created for this CSV row. Current legal values are `Collection`, `Work`, and `ChildWork`. Only one value can be given per CSV row.

Currently, `Manuscript` is also accepted as a synonym of `Work` and `Page` as a synonym of `ChildWork`, but this functionality may be removed at some point in the future.

This field is a string. **This field is required**.

Examples:

- `Work` (single value)

### Parent ARK (required)

The ark value of this object's hierarchical parent. For a single-image `Work` object, this will be the ark of a `Collection` object. When we start importing multi-page objects, this will become more complex.

This field is a string. **This field is required for Work objects**.

Examples:

- `ark:/21198/zz002h2fpt` (single value)

### Rights.copyrightStatus (required)

The copyright status of this work. The only currently allowed value is `copyrighted`.

This field is a string. **This field is required**.

Examples:

- `copyrighted` (single value)

### Title (required)

A name to aid in identifying a work.

This field is a string. **This field is required**.

Examples:

- `[Fannie Lou Hamer, Mississippi Freedom Democratic Party delegate, at the Democratic National Convention, Atlantic City, New Jersey, August 1964] / [WKL].` (single value)
- `[Fannie Lou Hamer, Mississippi Freedom Democratic Party delegate, at the Democratic National Convention, Atlantic City, New Jersey, August 1964] / [WKL].|~|Fannie Lou Hamer Portrait` (multivalued)

## Other Allowed Fields

### AltIdentifier.local

A local identifier. Can be multivalued.

Examples:

- `uclamss_686_b6_f24_18` (single value)
- `uclamss_686_b6_f24_18|~|uclamss_abc1234` (multivalued)

### AltTitle.other

accepts AltTitle.translated

### AltTitle.uniform

### Author

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

### Item Sequence

### Language

### Name.architect

### Name.photographer

### Name.repository

### Name.subject

### Place of origin

### Project Name

### Publisher.publisherName

### Relation.isPartOf

### Rights.countryCreation

### Rights.rightsHolderContact

### Subject

### Summary

### Support

### Type.genre

### Type.typeOfResource

### Visibility

A single-value field that must contain one of the allowed values.

This field is not required. If you omit this column or leave the value blank, it will default to `private` visibility (to avoid accidentally exposing records that should be restricted).

Examples:

- `public` - All users can view the record
- `authenticated` - Logged in users can view the record
- `discovery` - All users can view the metadata, but not the files
- `private` - Only admin users or users who have been granted special permission may view the record
