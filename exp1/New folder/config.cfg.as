[Configuration]
Protocols: ['pio_write','pio_read','mondo','ntw_data']
Message_width: {'approach': 1, 'lower': 1, 'enter': 1, 'exit': 1, 'rais': 1, 'pioreq': 65, 'piowcrd': 6, 'dmusiidata': 130, 'reqtot': 1, 'grant': 1, 'siincu': 32, 'monacknack': 8, 'niusiidata': 130, 'siil2t': 32, 'l2tmcu': 41, 'mcul2tack': 1, 'mcul2tdata': 134, 'l2bsio': 34, 'siodmu': 130, 'initdatatxfr': 1, 'datatxfr': 130, 'readreqpcx': 1, 'datapacket': 4, 'readackcpxncuload':1, 'ncucpxreq':8, 'ncucpxdata':146, 'cpxncugnt':8}
Buffer_width: 32

[a]
protocolnodes: [('far',), ('near',), ('in',)]
protocol: {('far',): {'approach': [('near',)]}, ('near',): {'enter': [('in',)]}, ('in',): {'exit': [('far',)]}}

[b]
protocolnodes: [('0',), ('1',), ('2',), ('3',)]
protocol: {('0',): {'approach': [('1',)]}, ('1',): {'lower': [('2',)]}, ('2',): {'exit': [('3',)]}, ('3',): {'rais': [('0',)]}}

[c]
protocolnodes: [('up',), ('down',)]
protocol: {('up',): {'lower': [('down',)]}, ('down',): {'rais': [('up',)]}}

[pio_write]
protocolnodes: [('piow_1',), ('piow_2',), ('piow_3',)]
protocol: {('piow_1',): {'pioreq': [('piow_2',)]}, ('piow_2',): {'piowcrd': [('piow_3',)]}}

[pio_read]
protocolnodes: [('pior_1',), ('pior_2',), ('pior_3',), ('pior_4',), ('pior_5',), ('pior_6',), ('pior_7',)]
protocol: {('pior_1',): {'pioreq': [('pior_2',)]}, ('pior_2',): {'dmusiidata': [('pior_3',)]}, ('pior_3',): {'dmusiidata': [('pior_4',)]}, ('pior_4',): {'reqtot': [('pior_5',)]}, ('pior_5',): {'grant': [('pior_6',)]}, ('pior_6',): {'siincu': [('pior_7',)]}}

[mondo]
protocolnodes: [('mon_1',), ('mon_2',), ('mon_3',), ('mon_4',), ('mon_5',), ('mon_6',), ('mon_7',), ('mon_8',)]
protocol: {('mon_1',): {'dmusiidata': [('mon_2',)]}, ('mon_2',): {'dmusiidata': [('mon_3',)]}, ('mon_3',): {'reqtot': [('mon_4',)]}, ('mon_4',): {'grant': [('mon_5',)]}, ('mon_5',): {'siincu': [('mon_6',)]}, ('mon_6',): {'siincu': [('mon_7',)]}, ('mon_7',): {'monacknack': [('mon_8',)]}}

[ntw_data]
protocolnodes: [('ntw_1',), ('ntw_2',), ('ntw_3',), ('ntw_4',), ('ntw_5',), ('ntw_6',), ('ntw_7',)]
protocol: {('ntw_1',): {'niusiidata': [('ntw_2',)]}, ('ntw_2',): {'niusiidata': [('ntw_3',)]}, ('ntw_3',): {'reqtot': [('ntw_4',)]}, ('ntw_4',): {'grant': [('ntw_5',)]}, ('ntw_5',): {'siincu': [('ntw_6',)]}, ('ntw_6',): {'siincu': [('ntw_7',)]}}

[dma_read]
protocolnodes: [('dmar_1',), ('dmar_2',), ('dmar_3',), ('dmar_4',), ('dmar_5',), ('dmar_6',), ('dmar_7',), ('dmar_8',), ('dmar_9',), ('dmar_10',), ('dmar_11',)]
protocol: {('dmar_1',): {'dmusiidata': [('dmar_2',)]}, ('dmar_2',): {'dmusiidata': [('dmar_3',)]}, ('dmar_3',): {'siil2t': [('dmar_4',)]}, ('dmar_4',): {'l2tmcu': [('dmar_5',)]}, ('dmar_5',): {'mcul2tack': [('dmar_6',)]}, ('dmar_6',): {'mcul2tdata': [('dmar_7',)]}, ('dmar_7',): {'l2bsio': [('dmar_8',)]}, ('dmar_8',): {'l2bsio': [('dmar_9',)]}, ('dmar_9',): {'siodmu': [('dmar_10',)]}, ('dmar_10',): {'siodmu': [('dmar_11',)]}}

[upstream_ncu]
protocolnodes: [('uncu_1',), ('uncu_2',), ('uncu_3',), ('uncu_4',), ('uncu_5',), ('uncu_6',)]
protocol: {('uncu_1',): {'readackcpxncuload': [('uncu_2',)]}, ('uncu_2',): {'datapacket': [('uncu_3',)]}, ('uncu_3',): {'ncucpxreq': [('uncu_4',)]}, ('uncu_4',): {'ncucpxdata': [('uncu_5',)]}, ('uncu_5',): {'cpxncugnt': [('uncu_6',)]}}

[downstream_ncu]
protocolnodes: [('dncu_1',), ('dncu_2',), ('dncu_3',), ('dncu_4',), ('dncu_5',)]
protocol: {('dncu_1',): {'initdatatxfr': [('dncu_2',)]}, ('dncu_2',): {'datatxfr': [('dncu_3',)]}, ('dncu_3',): {'readreqpcx': [('dncu_4',)]}, ('dncu_4',): {'datapacket': [('dncu_5',)]}}