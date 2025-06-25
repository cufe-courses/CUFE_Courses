from scrapy.conf import settings
from scrapy.exporters import CsvItemExporter


class CsvSetDelimItemExporter(CsvItemExporter):
    def __init__(self, *args, **kwargs):
        delimiter = settings.get('CSV_DELIMITER', '\t')
        kwargs['delimiter'] = delimiter
        super(CsvSetDelimItemExporter, self).__init__(*args, **kwargs)
