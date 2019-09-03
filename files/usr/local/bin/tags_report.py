import boto3
import argparse
import csv
from os import environ

field_names = ['Account', 'ResourceArn', 'TagKey', 'TagValue']
field_names_tags = ['TagName']
field_names_tags_values = ['TagName', 'Value']
tags = {}

def writeToCsv(writer, args, tag_list):
    for resource in tag_list:
        print("Extracting tags for resource: " +
              resource['ResourceARN'] + "...")
        for tag in resource['Tags']:
            try:
                tags[tag['Key']][tag['Value']] = ''
            except KeyError:
                tags[tag['Key']] = dict()
                tags[tag['Key']][tag['Value']] = ''
            row = dict(
                Account=environ['AWS_PROFILE'],
                ResourceArn=resource['ResourceARN'], TagKey=tag['Key'], TagValue=tag['Value'])
            writer.writerow(row)

def input_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", required=True,
                        help="Output CSV file (eg, /tmp/tagged-resources.csv)")
    return parser.parse_args()

def main():
    args = input_args()
    restag = boto3.client('resourcegroupstaggingapi')
    with open(args.output + '.csv', 'w') as csvfile:
        writer = csv.DictWriter(csvfile, quoting=csv.QUOTE_ALL,
                                delimiter=',', dialect='excel', fieldnames=field_names)
        writer.writeheader()
        response = restag.get_resources(ResourcesPerPage=50)
        writeToCsv(writer, args, response['ResourceTagMappingList'])
        while 'PaginationToken' in response and response['PaginationToken']:
            token = response['PaginationToken']
            response = restag.get_resources(
                ResourcesPerPage=50, PaginationToken=token)
            writeToCsv(writer, args, response['ResourceTagMappingList'])

    with open(args.output + '_tags.csv', 'w') as csvfile:
        writer = csv.DictWriter(csvfile, quoting=csv.QUOTE_ALL,
                                     delimiter=',', dialect='excel', fieldnames=field_names_tags)
        writer.writeheader()

        for tag in sorted(tags):
            row = dict(TagName=tag)
            writer.writerow(row)

    with open(args.output + '_tags_values.csv', 'w') as csvfile:
        writer = csv.DictWriter(csvfile, quoting=csv.QUOTE_ALL,
                                delimiter=',', dialect='excel', fieldnames=field_names_tags_values)
        writer.writeheader()

        for tag in sorted(tags):
            for value in tags[tag]:
                row = dict(TagName=tag, Value=value)
                writer.writerow(row)

if __name__ == '__main__':
    main()