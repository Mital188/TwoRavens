# -*- coding: utf-8 -*-
# Generated by Django 1.11.4 on 2017-11-27 22:07
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('configurations', '0005_auto_20171120_1555'),
    ]

    operations = [
        migrations.AlterField(
            model_name='appconfiguration',
            name='app_domain',
            field=models.CharField(choices=[('D3M_DOMAIN', 'D3M_DOMAIN'), ('DATAVERSE_DOMAIN', 'DATAVERSE_DOMAIN'), ('EVENTDATA_DOMAIN', 'EVENTDATA_DOMAIN')], help_text='.js variable "APP_DOMAIN"', max_length=70),
        ),
        migrations.AlterField(
            model_name='appconfiguration',
            name='d3m_svc_url',
            field=models.CharField(default='/d3m-service', help_text='.js variable "D3M_SVC_URL". This url is used to make calls that are converted to gRPC messages and sent to D3M applications', max_length=255, verbose_name='D3M service url'),
        ),
        migrations.AlterField(
            model_name='appconfiguration',
            name='dataverse_url',
            field=models.URLField(help_text='.js variable "DATAVERSE_URL"URL to Dataverseexamples: https://beta.dataverse.org,https://dataverse.harvard.edu', verbose_name='Dataverse url'),
        ),
        migrations.AlterField(
            model_name='appconfiguration',
            name='production',
            field=models.BooleanField(help_text='.js variable "PRODUCTION". True -> data, metadata from live server resources instead of local versions'),
        ),
        migrations.AlterField(
            model_name='appconfiguration',
            name='rook_svc_url',
            field=models.CharField(default='/rook-custom/', help_text='.js variable "ROOK_SVC_URL". This url is used to access the rook server. examples: https://beta.dataverse.org/custom/, http://127.0.0.1:8080/rook-custom/', max_length=255, verbose_name='Rook service url'),
        ),
    ]
