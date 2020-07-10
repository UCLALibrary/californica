/*
  This is a basic skeleton JavaScript update processor.

  In order for this to be executed, it must be properly wired into solrconfig.xml; by default it is commented out in
  the example solrconfig.xml and must be uncommented to be enabled.

  See http://wiki.apache.org/solr/ScriptUpdateProcessor for more details.
*/

function processAdd(cmd) {
  doc = cmd.solrDoc; // org.apache.solr.common.SolrInputDocument
  id = doc.getFieldValue('id');
  logger.info('update-script#processAdd: id=' + id);

  title = doc.getFieldValue('title');
  logger.info('update-script#processAdd: title=' + title);
  //xmlHttp = new XMLHttpRequest();
  var URL = Java.type('java.net.URL');
  url = new URL('http://example.com');
  logger.info('update-script#processAdd: URL=' + url);

  // copy "ursus_id_ssi":"21198-zz0026vwmn" to "id":"21198-zz0026vwmn" in ursus solr core

  // Set a field value:
  //  doc.setField("foo_s", "whatever");

  // Get a configuration parameter:
  //  config_param = params.get('config_param');  // "params" only exists if processor configured with <lst name="params">

  // Get a request parameter:
  // some_param = req.getParams().get("some_param")

  // Add a field of field names that match a pattern:
  //   - Potentially useful to determine the fields/attributes represented in a result set, via faceting on field_name_ss
  //  field_names = doc.getFieldNames().toArray();
  //  for(i=0; i < field_names.length; i++) {
  //    field_name = field_names[i];
  //    if (/attr_.*/.test(field_name)) { doc.addField("attribute_ss", field_names[i]); }
  //  }
}

function processDelete(cmd) {
  // no-op
}

function processMergeIndexes(cmd) {
  // no-op
}

function processCommit(cmd) {
  // no-op
}

function processRollback(cmd) {
  // no-op
}

function finish() {
  // no-op
}
